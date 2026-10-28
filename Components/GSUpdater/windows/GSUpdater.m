/* GSUpdater on Windows: WinSparkle (GSUpdater.h). */

#import "../GSUpdater.h"
#import <AppKit/NSApplication.h>

#include <windows.h>

typedef void (*GSSparkleVoid)(void);
typedef void (*GSSparkleString)(const char *);
typedef int (*GSSparkleKey)(const char *);
typedef void (*GSSparkleDetails)(const wchar_t *, const wchar_t *, const wchar_t *);
typedef void (*GSSparkleWide)(const wchar_t *);
typedef void (*GSSparkleCallback)(void (*)(void));

static GSSparkleVoid	sparkleCheck = NULL;
static GSSparkleVoid	sparkleCleanup = NULL;

/* WinSparkle asks for the application to go before it runs the installer,
   on a thread of its own: the application is told on its main one. */
static void
sparkleShutdown(void)
{
  [NSApp performSelectorOnMainThread: @selector(terminate:)
			  withObject: nil
		       waitUntilDone: NO];
}

/* A string as Windows' wide ones are (UTF-16), ended. */
static NSData *
wide(NSString *string)
{
  NSMutableData	*data;

  data = [[[string dataUsingEncoding: NSUTF16LittleEndianStringEncoding]
    mutableCopy] autorelease];
  if (data == nil)
    {
      data = [NSMutableData data];
    }
  [data appendBytes: "\0\0" length: 2];
  return data;
}

@implementation GSUpdater
{
  BOOL	_started;
}

- (BOOL) _start
{
  NSDictionary		*info = [[NSBundle mainBundle] infoDictionary];
  NSString		*feed = [info objectForKey: @"SUWindowsFeedURL"];
  NSString		*key = [info objectForKey: @"SUPublicEDKey"];
  NSString		*name;
  NSString		*version;
  NSString		*build;
  NSString		*company;
  NSArray		*identifier;
  HMODULE		sparkle;
  GSSparkleString	setURL;
  GSSparkleKey		setKey;
  GSSparkleDetails	setDetails;
  GSSparkleWide		setBuild;
  GSSparkleCallback	setShutdown;
  GSSparkleVoid		initialize;

  if ([feed length] == 0 || [key length] == 0)
    {
      return NO;
    }
  sparkle = LoadLibraryW(L"WinSparkle.dll");
  if (sparkle == NULL)
    {
      return NO;
    }
  setURL = (GSSparkleString)GetProcAddress(sparkle, "win_sparkle_set_appcast_url");
  setKey = (GSSparkleKey)GetProcAddress(sparkle, "win_sparkle_set_eddsa_public_key");
  setDetails = (GSSparkleDetails)GetProcAddress(sparkle, "win_sparkle_set_app_details");
  setBuild = (GSSparkleWide)GetProcAddress(sparkle, "win_sparkle_set_app_build_version");
  setShutdown = (GSSparkleCallback)GetProcAddress(sparkle, "win_sparkle_set_shutdown_request_callback");
  initialize = (GSSparkleVoid)GetProcAddress(sparkle, "win_sparkle_init");
  sparkleCheck = (GSSparkleVoid)GetProcAddress(sparkle, "win_sparkle_check_update_with_ui");
  sparkleCleanup = (GSSparkleVoid)GetProcAddress(sparkle, "win_sparkle_cleanup");
  if (setURL == NULL || setKey == NULL || setDetails == NULL || setBuild == NULL
    || initialize == NULL || sparkleCheck == NULL || sparkleCleanup == NULL)
    {
      return NO;
    }

  setURL([feed UTF8String]);
  /* A feed signed with another key is refused, as on the Mac. */
  if (setKey([key UTF8String]) == 0)
    {
      return NO;
    }
  name = [info objectForKey: @"ApplicationName"];
  if (name == nil)
    {
      name = [[NSProcessInfo processInfo] processName];
    }
  version = [info objectForKey: @"ApplicationRelease"];
  build = [[info objectForKey: @"CFBundleVersion"] description];
  /* WinSparkle's settings go under HKCU\Software\<company>\<name>: the
     bundle identifier's organization. */
  identifier = [[info objectForKey: @"CFBundleIdentifier"]
    componentsSeparatedByString: @"."];
  company = [identifier count] > 1 ? [identifier objectAtIndex: 1] : name;
  setDetails([wide(company) bytes], [wide(name) bytes],
    [wide(version ? version : @"0") bytes]);
  setBuild([wide(build ? build : @"0") bytes]);
  if (setShutdown != NULL)
    {
      setShutdown(sparkleShutdown);
    }
  initialize();
  [[NSNotificationCenter defaultCenter]
    addObserver: self
       selector: @selector(_applicationWillTerminate:)
	   name: NSApplicationWillTerminateNotification
	 object: nil];
  return YES;
}

- (void) _applicationWillTerminate: (NSNotification *)notification
{
  sparkleCleanup();
}

- (id) initStarting: (BOOL)start
{
  if ((self = [super init]) != nil && start)
    {
      _started = [self _start];
    }
  return self;
}

- (void) dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver: self];
  [super dealloc];
}

- (BOOL) available
{
  return _started;
}

- (BOOL) canCheckForUpdates
{
  return _started;
}

- (void) checkForUpdates: (id)sender
{
  if (_started)
    {
      sparkleCheck();
    }
}

@end
