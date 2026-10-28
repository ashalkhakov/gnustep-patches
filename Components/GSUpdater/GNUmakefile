#
# GSUpdater: an application's updates (GSUpdater.h), WinSparkle on Windows,
# none on Linux; the stack's own, built after the GUI (Scripts/build-gnustep.sh).
#
include $(GNUSTEP_MAKEFILES)/common.make

LIBRARY_NAME = GSUpdater

ifeq ($(GNUSTEP_TARGET_OS),mingw32)
GSUpdater_OBJC_FILES = windows/GSUpdater.m
else ifeq ($(GNUSTEP_TARGET_OS),windows)
GSUpdater_OBJC_FILES = windows/GSUpdater.m
else
GSUpdater_OBJC_FILES = posix/GSUpdater.m
endif

GSUpdater_HEADER_FILES_DIR = .
GSUpdater_HEADER_FILES_INSTALL_DIR = GSUpdater
GSUpdater_HEADER_FILES = GSUpdater.h

GSUpdater_LIBRARIES_DEPEND_UPON = -lgnustep-gui -lgnustep-base -lobjc

include $(GNUSTEP_MAKEFILES)/library.make
