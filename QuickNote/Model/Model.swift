//
//  NoteModel.swift
//  QuickNote
//
//  Created by Ruchira  on 17/04/24.
//

import CoreData

   enum Section: Hashable {
       case main
   }

   @objc(Note)
   public class QuickNote: NSManagedObject {

       @NSManaged public var title: String
       @NSManaged public var body: String
       @NSManaged public var created: Date

   }

   extension QuickNote {
       @nonobjc public class func fetchRequest() ->
            NSFetchRequest<QuickNote> {
           NSFetchRequest<QuickNote>(entityName: "Note")
       }
   }


