/* GSUpdater on Linux and the other POSIX systems: none (GSUpdater.h). */

#import "../GSUpdater.h"

@implementation GSUpdater

- (id) initStarting: (BOOL)start
{
  return [super init];
}

- (BOOL) available
{
  return NO;
}

- (BOOL) canCheckForUpdates
{
  return NO;
}

- (void) checkForUpdates: (id)sender
{
}

@end
