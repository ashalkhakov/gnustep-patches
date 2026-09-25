/* Repro for Patches/gnustep-gui-pdf-print-operation.patch
 *
 * A flipped view that paginates itself -- three pages, each with its title at
 * the top -- printed to PDF with +[NSPrintOperation
 * PDFOperationWithView:insideRect:toData:printInfo:].
 *
 * The page count is checked here and decides PASS/FAIL: three pages with the
 * patch, one without it. The orientation is not machine-checkable without
 * rasterizing, so the PDF is also written to
 * /tmp/pdf-print-operation-test.pdf: open it and read the first line.
 *
 * The cairo backend writes its page objects into FlateDecode streams, so the
 * count has to inflate them; a scan of the raw bytes finds nothing at all and
 * reads as "this system produces no page objects" when it means "they are
 * zipped". That is what made this look unassertable here.
 *
 *   clang pdf-print-operation-test.m -o pdftest -D_GNU_SOURCE \
 *     -fobjc-runtime=gnustep-2.0 -fexceptions -fblocks \
 *     -I$PREFIX/include -I$PREFIX/Local/Library/Headers \
 *     -L$PREFIX/lib -L$PREFIX/Local/Library/Libraries \
 *     -Wl,-rpath-link,$PREFIX/lib -Wl,--no-as-needed \
 *     -lgnustep-gui -lgnustep-base -lobjc -lz
 *   xvfb-run -a ./pdftest
 */
#import <AppKit/AppKit.h>
#include <string.h>
#include <zlib.h>

@interface PaginatedView : NSView
@end

@implementation PaginatedView

// Report coordinates run from the top of the page down, as they do in any
// document view; this is what the print operation is supposed to honour.
- (BOOL)isFlipped { return YES; }

- (BOOL)knowsPageRange:(NSRange *)range {
  range->location = 1;
  range->length = 3;
  return YES;
}

- (NSRect)rectForPage:(NSInteger)page {
  return NSMakeRect(0, (page - 1) * 792.0, 612.0, 792.0);
}

- (void)drawRect:(NSRect)dirtyRect {
  (void)dirtyRect;
  NSDictionary *attrs = @{
    NSFontAttributeName : [NSFont userFontOfSize:36] ?: [NSFont systemFontOfSize:36]
  };
  [[NSColor whiteColor] set];
  NSRectFill([self bounds]);
  for (NSInteger page = 1; page <= 3; page++) {
    CGFloat top = (page - 1) * 792.0;
    // Near the top of the page, and only there: if the output is flipped this
    // ends up at the foot, with the glyphs upside down.
    NSString *label = [NSString stringWithFormat:@"TOP OF PAGE %ld", (long)page];
    [label drawAtPoint:NSMakePoint(72, top + 72) withAttributes:attrs];
    [[NSColor blackColor] set];
    NSRectFill(NSMakeRect(72, top + 36, 468, 4));
  }
}

@end

// The page objects, wherever they are. A PDF may carry them as plain text or
// inside a FlateDecode stream, and this backend compresses: looking only at
// the raw bytes finds none at all, which reads as "this system produces no
// page objects" when what it means is "they are zipped".
static NSUInteger CountInText(const char *bytes, NSUInteger length) {
  NSUInteger pages = 0;
  const char *needle = "/Type /Page";
  NSUInteger needleLength = strlen(needle);
  for (NSUInteger i = 0; i + needleLength <= length; i++) {
    if (memcmp(bytes + i, needle, needleLength) != 0)
      continue;
    // "/Type /Pages" is the tree node, not a page.
    if (i + needleLength < length && bytes[i + needleLength] == 's')
      continue;
    pages++;
  }
  return pages;
}

static NSUInteger CountPageObjects(NSData *pdf) {
  const char *bytes = [pdf bytes];
  NSUInteger length = [pdf length];
  NSUInteger pages = CountInText(bytes, length);
  // Every stream in the file, inflated where it inflates.
  for (NSUInteger i = 0; i + 7 <= length; i++) {
    if (memcmp(bytes + i, "stream", 6) != 0)
      continue;
    NSUInteger start = i + 6;
    if (start < length && bytes[start] == '\r')
      start++;
    if (start < length && bytes[start] == '\n')
      start++;
    const char *end = memmem(bytes + start, length - start, "endstream", 9);
    if (end == NULL)
      break;
    NSUInteger compressed = (NSUInteger)(end - (bytes + start));
    uLongf room = (uLongf)(compressed * 20 + 4096);
    Bytef *out = malloc(room);
    if (out == NULL)
      break;
    if (uncompress(out, &room, (const Bytef *)(bytes + start), (uLong)compressed) == Z_OK)
      pages += CountInText((const char *)out, (NSUInteger)room);
    free(out);
    i = (NSUInteger)(end - bytes) + 8;
  }
  return pages;
}

int main(void) {
  @autoreleasepool {
    [NSApplication sharedApplication];

    PaginatedView *view = [[PaginatedView alloc] initWithFrame:NSMakeRect(0, 0, 612, 3 * 792)];

    NSPrintInfo *info = [[NSPrintInfo alloc] initWithDictionary:@{}];
    [info setPaperSize:NSMakeSize(612, 792)];
    [info setLeftMargin:0];
    [info setRightMargin:0];
    [info setTopMargin:0];
    [info setBottomMargin:0];

    NSMutableData *data = [NSMutableData data];
    NSPrintOperation *op = [NSPrintOperation PDFOperationWithView:view
                                                      insideRect:[view bounds]
                                                          toData:data
                                                       printInfo:info];
    if (![op runOperation]) {
      printf("FAIL: the print operation did not run\n");
      return 1;
    }
    if ([data length] == 0) {
      printf("FAIL: no PDF data\n");
      return 1;
    }
    [data writeToFile:@"/tmp/pdf-print-operation-test.pdf" atomically:YES];

    // Count the page objects. The view says it has three pages; a PDF made
    // from it must have three.
    NSUInteger pages = CountPageObjects(data);

    printf("pages in the PDF: %lu (the view says 3)\n", (unsigned long)pages);
    printf("written to /tmp/pdf-print-operation-test.pdf --"
           " the first line should read \"TOP OF PAGE 1\", the right way up,"
           " near the top\n");
    if (pages != 3) {
      printf("FAIL: pagination was ignored\n");
      return 1;
    }
    printf("PASS: one PDF page per page of the view\n");
    return 0;
  }
}
