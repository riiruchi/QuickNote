//
//  NoteModel.swift
//  QuickNote
//
//  Created by Ruchira  on 17/04/24.
//

import CoreData
    
/**
   Enumeration representing sections within the `QuickNote` entity.
*/

enum Section: Hashable {
    /// Represents the main section.
    case main
}

/**
   Represents a Quick Note entity managed by Core Data.
*/

@objc(Note)
public class QuickNote: NSManagedObject {

    @NSManaged public var title: String
    @NSManaged public var body: String
    @NSManaged public var created: Date
}

/**
Creates a fetch request for `QuickNote` entities.
- Returns: A fetch request for `QuickNote` entities.
*/

extension QuickNote {
    @nonobjc public class func fetchRequest() ->
        NSFetchRequest<QuickNote> {
        NSFetchRequest<QuickNote>(entityName: "Note")
       }
}
