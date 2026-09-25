/* Repro for 0001-graphicscontext-backend-recursion.patch
 *
 * A view printed to PDF in a process that never made an NSApplication --
 * a report generator, say, which has no reason to make one.
 *
 * Without the patch this program never returns: +[NSGraphicsContext
 * allocWithZone:] forwards to defaultNSGraphicsContextClass, which is still
 * NSGraphicsContext itself until a backend replaces it, so it calls itself
 * for ever. The process spins at 100% with no output; a backtrace names only
 * objc_msgSend_stret under +graphicsContextWithAttributes:, which says
 * nothing about the cause.
 *
 * With the patch it raises NSInternalInconsistencyException at once, naming
 * the missing backend, and the process exits 134 rather than sitting until
 * something kills it.
 *
 * Run it under a timeout, since the fault is a hang:
 *
 *   clang graphicscontext-backend-recursion-test.m -o backendtest \
 *     -fobjc-runtime=gnustep-2.0 -fexceptions -fblocks \
 *     -I$PREFIX/include -I$PREFIX/Local/Library/Headers \
 *     -L$PREFIX/lib -L$PREFIX/Local/Library/Libraries \
 *     -Wl,-rpath-link,$PREFIX/lib -Wl,--no-as-needed \
 *     -lgnustep-gui -lgnustep-base -lobjc
 *   timeout 45 xvfb-run -a ./backendtest; echo "exit=$?"
 *
 * exit=124 is the fault (killed by timeout); exit=134 is the fix (SIGABRT
 * from the uncaught exception). Adding [NSApplication sharedApplication] as
 * the first statement makes it print a byte count either way, which is why
 * this bug is easy to miss: a program written to demonstrate a GUI fault
 * naturally starts by making the application.
 */
#import <AppKit/AppKit.h>

@interface Sheet : NSView
@end

@implementation Sheet
- (BOOL)isFlipped { return YES; }
- (void)drawRect:(NSRect)r {
  [[NSColor whiteColor] set];
  NSRectFill(r);
  [@"Hello" drawAtPoint:NSMakePoint(20, 20) withAttributes:nil];
}
@end

int main(void) {
  @autoreleasepool {
    // Deliberately no [NSApplication sharedApplication]: that is what loads
    // the backend, and what this is about.
    Sheet *view = [[Sheet alloc] initWithFrame:NSMakeRect(0, 0, 612, 792)];
    NSPrintInfo *info = [[NSPrintInfo alloc] initWithDictionary:@{}];
    [info setPaperSize:NSMakeSize(612, 792)];
    [info setLeftMargin:0];
    [info setRightMargin:0];
    [info setTopMargin:0];
    [info setBottomMargin:0];
    NSMutableData *data = [NSMutableData data];
    fprintf(stderr, "before runOperation\n");
    fflush(stderr);
    NSPrintOperation *op = [NSPrintOperation PDFOperationWithView:view
                                                       insideRect:[view bounds]
                                                           toData:data
                                                        printInfo:info];
    [op runOperation];
    fprintf(stderr, "returned: %lu bytes -- the backend was loaded after all\n",
            (unsigned long)[data length]);
    fflush(stderr);
  }
  return 0;
}
