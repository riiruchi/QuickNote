//
//  NoteViewModel.swift
//  QuickNote
//
//  Created by Ruchira  on 18/04/24.
//

import Foundation
import CoreData

class NotesViewModel {
    private let managedContext: NSManagedObjectContext
        
        var notes: [QuickNote] = []
        
        init(managedContext: NSManagedObjectContext) {
            self.managedContext = managedContext
        }
        
        func fetchNotes(completion: @escaping () -> Void) {
            do {
                notes = try managedContext.fetch(QuickNote.fetchRequest())
                completion()
            } catch let error as NSError {
                fatalError("Unable to fetch. \(error) = \(error.userInfo)")
            }
        }
        
        func deleteNote(at index: Int, completion: @escaping () -> Void) {
            let note = notes[index]
            
            managedContext.delete(note)
            
            do {
                try managedContext.save()
                completion()
            } catch let error as NSError {
                fatalError("\(error.userInfo)")
            }
        }
}

