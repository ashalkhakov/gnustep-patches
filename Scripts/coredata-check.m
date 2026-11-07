/* The stack's Core Data (FreeCoreData), as an application uses it: a model
   made in code, an in-memory store, an object inserted, saved and fetched.
   Built and run by stack.yml's Check, against the prefix as it is shipped. */
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

int main(void) {
    @autoreleasepool {
        NSAttributeDescription *text = [[NSAttributeDescription alloc] init];
        text.name = @"text";
        text.attributeType = NSStringAttributeType;
        NSEntityDescription *note = [[NSEntityDescription alloc] init];
        note.name = @"Note";
        note.managedObjectClassName = @"NSManagedObject";
        note.properties = @[ text ];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] init];
        model.entities = @[ note ];

        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSError *error = nil;
        if (![coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
            NSLog(@"no store: %@", error);
            return 1;
        }
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        context.persistentStoreCoordinator = coordinator;
        [[NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context] setValue:@"hello" forKey:@"text"];
        if (![context save:&error]) {
            NSLog(@"not saved: %@", error);
            return 1;
        }
        NSArray *notes = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Note"] error:&error];
        printf("%s %lu\n", [[notes.firstObject valueForKey:@"text"] UTF8String], (unsigned long)notes.count);
    }
    return 0;
}
