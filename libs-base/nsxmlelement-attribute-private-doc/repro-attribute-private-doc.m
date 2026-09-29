/* -[NSXMLElement addAttribute:] frees the private document a prefixed
 * attribute was given, but the attribute still records it as its own.
 * Once another document is allocated at that address, -detach takes the
 * attribute for already detached and leaves it in the tree, which then
 * frees it under the attribute object; the object's -dealloc writes into
 * the freed node.  With glibc this aborts within a few thousand trees:
 *
 *     malloc_consolidate(): unaligned fastbin chunk detected
 *
 * Build: clang -fobjc-arc $(gnustep-config --objc-flags) \
 *     repro-attribute-private-doc.m $(gnustep-config --base-libs)
 */
#import <Foundation/Foundation.h>

int main(void)
{
	for (int i = 0; i < 20000; i++) {
		@autoreleasepool {
			NSXMLElement *root = [NSXMLElement elementWithName:@"a:root"];
			[root addNamespace:[NSXMLNode namespaceWithName:@"a" stringValue:@"urn:a"]];
			[root addNamespace:[NSXMLNode namespaceWithName:@"b" stringValue:@"urn:b"]];
			NSXMLElement *list = [NSXMLElement elementWithName:@"a:list"];
			[root addChild:list];
			for (int j = 0; j < 5; j++) {
				NSXMLElement *item = [NSXMLElement elementWithName:@"a:item"];
				[list addChild:item];
				[item addAttribute:[NSXMLNode attributeWithName:@"id"
					stringValue:[NSString stringWithFormat:@"i%d", j]]];
				[item addAttribute:[NSXMLNode attributeWithName:@"b:kind" stringValue:@"k"]];
			}
			NSXMLDocument *document = [[NSXMLDocument alloc] initWithRootElement:root];
			[document setVersion:@"1.0"];
			[document setCharacterEncoding:@"UTF-8"];
			[document XMLStringWithOptions:NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement];
		}
	}
	printf("done\n");
	return 0;
}
