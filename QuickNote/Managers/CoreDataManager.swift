//
//  CoreDataManager.swift
//  QuickNote
//
//  Created by Ruchira  on 19/04/24.
//

import CoreData

/*
   CoreDataManager: Manages the Core Data stack and operations related to QuickNote entities.
   This class provides a singleton instance for accessing the Core Data stack and executing fetch and 
   save operations on QuickNote entities.
*/

class CoreDataManager {
    
    /*
     shared: The singleton instance of CoreDataManager.
     Access this property to obtain the shared instance of CoreDataManager for accessing the Core Data stack.
    */
    
    static let shared = CoreDataManager()
    
    /*
    persistentContainer: The NSPersistentContainer instance managing the Core Data stack.
    This property lazily initializes an NSPersistentContainer configured with the data model named "QuickNote".
    It loads the persistent stores and handles any errors during the process.
    */
    
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
    
    /*
    fetchNotes(): Fetches all QuickNote entities from the Core Data stack.
    - Throws: An error if there is any issue during the fetch operation.
    - Returns: An array of QuickNote entities fetched from the Core Data stack.
    */
    
    func fetchNotes() throws -> [QuickNote] {
        let request: NSFetchRequest<QuickNote> = QuickNote.fetchRequest()
        let context = persistentContainer.viewContext
        return try context.fetch(request)
    }
    
    /*
    saveNote(title:body:): Saves a new QuickNote entity with the provided title and body to the Core Data stack.
    - Parameters:
    - title: The title of the QuickNote.
    - body: The body content of the QuickNote.
    - Throws: An error if there is any issue during the save operation.
    */
    
    func saveNote(title: String, body: String) throws {
        let context = persistentContainer.viewContext
        let note = QuickNote(context: context)
        note.title = title
        note.body = body
        note.created = Date()
        
        try context.save()
    }
}
