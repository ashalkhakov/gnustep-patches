#import <Foundation/Foundation.h>
#import <GSUpdater/GSUpdater.h>
#import "Testing.h"

int main()
{
  NSAutoreleasePool	*pool = [NSAutoreleasePool new];
  GSUpdater		*updater;

  START_SET("GSUpdater")

  updater = [[[GSUpdater alloc] initStarting: NO] autorelease];
  PASS(updater != nil, "an updater is made without starting")
  PASS(![updater available], "one not started has no updates to give")
  PASS(![updater canCheckForUpdates], "and cannot check for them")
  [updater checkForUpdates: nil];
  PASS(YES, "checking with none does nothing")

  /* This program's bundle says no feed (SUWindowsFeedURL): started, it is
     still not available, on every system. */
  updater = [[[GSUpdater alloc] initStarting: YES] autorelease];
  PASS(updater != nil && ![updater available],
    "an application that names no feed has no updater")

  END_SET("GSUpdater")

  [pool release];
  return 0;
}
