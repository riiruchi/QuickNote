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
    
    func fetchNotes(completion: @escaping (Error?) -> Void) {
        let fetchRequest: NSFetchRequest<QuickNote> = QuickNote.fetchRequest()
        do {
            notes = try managedContext.fetch(fetchRequest)
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    func addNote(title: String, body: String, completion: @escaping (Error?) -> Void) {
        let note = QuickNote(context: managedContext)
        note.title = title
        note.body = body
        note.created = Date()
        
        do {
            try managedContext.save()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}

