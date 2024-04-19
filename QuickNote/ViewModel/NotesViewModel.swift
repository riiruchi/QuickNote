//
//  NoteViewModel.swift
//  QuickNote
//
//  Created by Ruchira  on 18/04/24.
//

import Foundation

/**
`NotesViewModel` manages the business logic related to handling notes within the application.
*/

class NotesViewModel {
    
    // MARK: - Success states
    /// Represents various success states of the `NotesViewModel`.
    enum State {
        /// Indicates the success state for fetching notes.
        case getNotes
    }

    // MARK: - View state
    /// The current view state of the `NotesViewModel`.
    var viewState: ViewState<State> = .empty {
        didSet {
            DispatchQueue.main.async {
                // Notify observers of view state changes.
                self.onViewStateChange?(self.viewState)
            }
        }
    }
    
    /// Closure to notify observers of view state changes.
    var onViewStateChange: ((_ viewState: ViewState<State>) -> Void)?
    
    /// The array of notes managed by the view model.
    private(set) var notes: [QuickNote] = []
    
    /**
    Fetches notes from the data source.
    */
    
    func fetchNotes() {
        do {
            // Fetch notes from the data manager.
            notes = try CoreDataManager.shared.fetchNotes()
            // Update the view state to indicate successful fetching of notes.
            self.viewState = .ready(.getNotes)

        } catch let error as NSError {
            // Update the view state to indicate an error occurred while fetching notes.
            self.viewState = .error(error)
        }
    }
}
