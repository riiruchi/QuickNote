//
//  CoreDataManager.swift
//  QuickNote
//
//  Created by Ruchira  on 19/04/24.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "QuickNote")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    func fetchNotes() throws -> [QuickNote] {
        let request: NSFetchRequest<QuickNote> = QuickNote.fetchRequest()
        let context = persistentContainer.viewContext
        return try context.fetch(request)
    }
    
    func saveNote(title: String, body: String) throws {
        let context = persistentContainer.viewContext
        let note = QuickNote(context: context)
        note.title = title
        note.body = body
        note.created = Date()
        
        try context.save()
    }
    
}
