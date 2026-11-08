/* Opens an NSOpenPanel with -beginSheetModalForWindow:completionHandler:
 * under WinUXTheme and checks that Windows' own dialog is shown and that
 * the file chosen there comes back from -URLs.  A second thread finds the
 * dialog, types the file's name into it and presses OK; if no native dialog
 * appears in ten seconds, the GNUstep panel is cancelled instead.
 *
 *   openpanel-sheet -GSTheme WinUXTheme      (exit 0: passed)
 */
#import <AppKit/AppKit.h>
#include <windows.h>

static NSString *chosen = @"chosen.txt";
static volatile BOOL sawNative = NO;

static BOOL CALLBACK findDialog(HWND w, LPARAM out)
{
  DWORD pid = 0;
  WCHAR cls[16];

  GetWindowThreadProcessId(w, &pid);
  if (pid == GetCurrentProcessId() && IsWindowVisible(w)
    && GetClassNameW(w, cls, 16) && wcscmp(cls, L"#32770") == 0)
    {
      *(HWND *)out = w;
      return FALSE;
    }
  return TRUE;
}

@interface Driver : NSObject
+ (void) drive: (id)unused;
+ (void) cancelGNUstepPanel: (id)unused;
@end

@implementation Driver
+ (void) drive: (id)unused
{
  int i;

  for (i = 0; i < 100; i++)
    {
      HWND dialog = NULL;

      Sleep(100);
      EnumWindows(findDialog, (LPARAM)&dialog);
      if (dialog != NULL)
        {
          sawNative = YES;
          Sleep(500);
          SetDlgItemTextW(dialog, 1148, (LPCWSTR)[chosen cStringUsingEncoding: NSUnicodeStringEncoding]);
          PostMessageW(dialog, WM_COMMAND, IDOK, 0);
          return;
        }
    }
  [self performSelectorOnMainThread: @selector(cancelGNUstepPanel:)
                         withObject: nil
                      waitUntilDone: NO
                              modes: [NSArray arrayWithObjects: NSDefaultRunLoopMode, NSModalPanelRunLoopMode, nil]];
}

+ (void) cancelGNUstepPanel: (id)unused
{
  [NSApp stopModalWithCode: NSModalResponseCancel];
}
@end

int main(int argc, const char **argv)
{
  NSAutoreleasePool *arp = [NSAutoreleasePool new];
  NSString *folder = [NSTemporaryDirectory() stringByAppendingPathComponent: @"openpanel-sheet"];
  NSString *file = [folder stringByAppendingPathComponent: chosen];
  NSOpenPanel *panel;
  __block NSInteger result = -1;
  __block NSString *got = nil;
  BOOL passed;

  [[NSFileManager defaultManager] createDirectoryAtPath: folder withIntermediateDirectories: YES attributes: nil error: NULL];
  [@"x" writeToFile: file atomically: YES encoding: NSUTF8StringEncoding error: NULL];
  [NSApplication sharedApplication];

  panel = [NSOpenPanel openPanel];
  [panel setCanChooseFiles: YES];
  [panel setCanChooseDirectories: NO];
  [panel setAllowsMultipleSelection: NO];
  [panel setDirectoryURL: [NSURL fileURLWithPath: folder]];
  [NSThread detachNewThreadSelector: @selector(drive:) toTarget: [Driver class] withObject: nil];
  [panel beginSheetModalForWindow: nil completionHandler: ^(NSInteger r) {
    result = r;
    got = [[[panel URLs] firstObject] path];
  }];

  passed = sawNative && result == NSModalResponseOK
    && [[got lowercaseString] isEqual: [[file stringByReplacingOccurrencesOfString: @"\\" withString: @"/"] lowercaseString]];
  printf("panel class %s, native dialog shown: %s, result %ld, URL %s (expected %s): %s\n",
    [NSStringFromClass([panel class]) UTF8String], sawNative ? "yes" : "no", (long)result,
    got ? [got UTF8String] : "(none)", [file UTF8String], passed ? "PASS" : "FAIL");
  [arp release];
  return passed ? 0 : 1;
}
