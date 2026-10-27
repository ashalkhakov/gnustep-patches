# framework-dll-install-build-dir

tools-make has no test suite of its own, so this is the reproduction. On
Windows (MSYS2 CLANG64), a framework built in a build directory other than
its source's:

```sh
mkdir Foo && cd Foo
printf '#import <Foundation/Foundation.h>\n@interface Foo : NSObject\n@end\n' > Foo.h
printf '#import "Foo.h"\n@implementation Foo\n@end\n' > Foo.m
printf 'include $(GNUSTEP_MAKEFILES)/common.make\nFRAMEWORK_NAME = Foo\nFoo_OBJC_FILES = Foo.m\nFoo_HEADER_FILES = Foo.h\ninclude $(GNUSTEP_MAKEFILES)/framework.make\n' > GNUmakefile
make GNUSTEP_BUILD_DIR=$PWD/../build
make GNUSTEP_BUILD_DIR=$PWD/../build DESTDIR=$PWD/../stage install
```

Without the fix the install stops at
`/usr/bin/install: cannot stat 'Foo.framework/./libFoo.dll.a'`; with it,
`Library/Libraries/libFoo.dll.a` is installed beside the framework and its
DLL. A build in the source directory (the default) installs either way.
