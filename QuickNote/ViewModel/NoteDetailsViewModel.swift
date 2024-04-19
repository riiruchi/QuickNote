//
//  NoteDetailsViewModel.swift
//  QuickNote
//
//  Created by Ruchira  on 20/04/24.
//

import Foundation

/**
   `NoteDetailsViewModel` manages the data and business logic related to displaying and editing a single note within the application.
*/
class NoteDetailsViewModel {
    
    /// The note being managed by the view model.
    var note: QuickNote?
    
    /**
    Configures the view model with the provided note.
    - Parameter note: The note to be configured with.
    */
    func configure(with note: QuickNote?) {
        self.note = note
    }
}
