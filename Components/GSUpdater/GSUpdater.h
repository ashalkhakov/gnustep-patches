/* GSUpdater: an application's updates, as Sparkle gives them on macOS.

   On Windows, WinSparkle: WinSparkle.dll (which gnustep-release-actions puts
   beside an installed application's runtime) is loaded when the updater
   starts, so a program without it has no updater. The application's
   Info-gnustep.plist says the rest, and gnustep-release-actions writes it
   into an installer's:

     SUWindowsFeedURL   the release's appcast-windows.xml
     SUPublicEDKey      the key the appcast is signed with (the Mac's)
     CFBundleVersion    the build, which the appcast's sparkle:version is
                        compared with (a GNUstep program has no version
                        resource for WinSparkle to read)
     ApplicationRelease, ApplicationName, CFBundleIdentifier
                        the version shown, the name, and the organization
                        WinSparkle keeps its settings under

   WinSparkle asks the application to terminate before it runs the
   installer. On Linux there is none: an AppImage is updated from outside it.
   One implementation for each system (posix/, windows/). */

#ifndef _GSUpdater_h_INCLUDE
#define _GSUpdater_h_INCLUDE

#import <Foundation/Foundation.h>

@interface GSUpdater : NSObject

/** Started at once, its automatic checks with it, unless told not to (a
    test reaches no network). */
- (id) initStarting: (BOOL)start;

/** Whether this application has an updater (Check for Updates... shown). */
- (BOOL) available;
- (BOOL) canCheckForUpdates;

/** Checks now, saying what it finds. */
- (void) checkForUpdates: (id)sender;

@end

#endif
