/* -[NSXMLElement addNamespace:] leaks its copy of a namespace whose prefix
 * the element already declares.  Only a leak checker sees it:
 *
 *   clang $(gnustep-config --objc-flags) -fobjc-arc -o addnamespace-leak \
 *     addnamespace-leak.m $(gnustep-config --base-libs)
 *   valgrind --leak-check=full --show-leak-kinds=definite ./addnamespace-leak
 *
 * Without the fix: "definitely lost: 96 bytes in 2 blocks", both allocated
 * in -[NSXMLElement addNamespace:].  With it: none.  Both runs print the
 * first declaration, which the element keeps:
 *
 *   prefix '': 1 namespace(s), <e xmlns="urn:x"></e>
 *   prefix 'a': 1 namespace(s), <e xmlns:a="urn:1"></e>
 *
 * (Apple's Foundation replaces it instead: xmlns="urn:y", xmlns:a="urn:2".)
 */
#import <Foundation/Foundation.h>

static void
twice(NSString *prefix, NSString *first, NSString *second)
{
  NSXMLElement *e = [NSXMLNode elementWithName: @"e"];

  [e addNamespace: [NSXMLNode namespaceWithName: prefix stringValue: first]];
  [e addNamespace: [NSXMLNode namespaceWithName: prefix stringValue: second]];
  printf("prefix '%s': %lu namespace(s), %s\n", [prefix UTF8String],
    (unsigned long)[[e namespaces] count], [[e XMLString] UTF8String]);
}

int main(void)
{
  @autoreleasepool
    {
      twice(@"", @"urn:x", @"urn:y");
      twice(@"a", @"urn:1", @"urn:2");
    }
  return 0;
}
