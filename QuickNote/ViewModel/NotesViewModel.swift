//
//  NoteViewModel.swift
//  QuickNote
//
//  Created by Ruchira  on 18/04/24.
//

import CoreData

class NotesViewModel {
    private var notes: [QuickNote] = []
    private let managedContext: NSManagedObjectContext
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func fetchNotes(completion: @escaping ([QuickNote]) -> Void) {
        do {
            notes = try managedContext.fetch(QuickNote.fetchRequest())
            completion(notes)
        } catch let error as NSError {
            print("Unable to fetch notes: \(error), \(error.userInfo)")
            completion([])
        }
    }
    
    func deleteItem(_ note: QuickNote, completion: @escaping () -> Void) {
        managedContext.delete(note)
        
        do {
            try managedContext.save()
            completion()
        } catch let error as NSError {
            print("Error deleting note: \(error), \(error.userInfo)")
        }
    }
}
