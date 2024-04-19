//
//  NoteViewModel.swift
//  QuickNote
//
//  Created by Ruchira  on 18/04/24.
//

import Foundation

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
    
    func fetchNotes() {
        do {
            notes = try CoreDataManager.shared.fetchNotes()
            self.viewState = .ready(.getNotes)

        } catch let error as NSError {
            self.viewState = .error(error)
        }
    }
}
