//
//  NoteViewModel.swift
//  QuickNote
//
//  Created by Ruchira  on 18/04/24.
//

import CoreData



class NotesViewModel {
    
    // MARK: - Success states
        enum State {
            case getNotes
        }

        // MARK: - View state
        var viewState: ViewState<State> = .empty {
            didSet {
                DispatchQueue.main.async {
                    self.onViewStateChange?(self.viewState)
                }
            }
        }

    var onViewStateChange: ((_ viewState: ViewState<State>) -> Void)?
    
    
    private(set) var notes: [QuickNote] = []
    private let managedContext: NSManagedObjectContext
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func fetchNotes() {
        
        guard let appDelegate = AppDelegate.getAppDelegate() else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        do {
            notes = try managedContext.fetch(QuickNote.fetchRequest())
            self.viewState = .ready(.getNotes)

        } catch let error as NSError {
            self.viewState = .error(error)
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
