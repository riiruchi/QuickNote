//
//  NoteDetailViewController.swift
//  QuickNote
//
//  Created by Ruchira  on 18/04/24.
//

import UIKit

/**
`NoteDetailViewController` manages the presentation and editing of a single note in the application.
It contains UI elements for displaying and modifying the title and body of the note.
*/

class NoteDetailViewController: UIViewController {
    // MARK: - Instance Variables
    private lazy var viewModel: NoteDetailsViewModel = NoteDetailsViewModel()
    
    /// The note to be displayed and edited by this view controller.
    var note: QuickNote?
    
    /// The text field for editing the title of the note.
    private var titleField: UITextField = {
        let field = UITextField()
        field.textColor = .label
        field.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return field
    }()
    
    /// The text view for editing the body of the note.
    private var bodyTextView: UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 18)
        view.textColor = .label
        view.clipsToBounds = true
        return view
    }()
    
    /**
    Overrides the `viewDidLoad()` method of the `UIViewController` superclass.
    This method is called after the view controller has loaded its view hierarchy into memory.
    It sets up the initial state of the view and populates UI elements with note data if available.
    */
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.configure(with: note)
        if let note = note {
            titleField.text = note.title
            bodyTextView.attributedText = note.body.getAttributedBodyText()
        }
    }
    
    /**
    Configures the view with data from the view model's note.
    If a note exists in the view model, sets the text of the title field to the note's title
    and sets the attributed text of the body text view to the note's body with attributed formatting applied.
    */
    
    private func configureView() {
        guard let note = viewModel.note else { return }
        titleField.text = note.title
        bodyTextView.attributedText = note.body.getAttributedBodyText()
    }
    
    /**
    Overrides the `viewWillLayoutSubviews()` method of the `UIViewController` superclass.
    This method is called just before the view's layout is updated.
    It adds the title field and body text view as subviews to the view and sets their frames based on the view's bounds.
    */
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubViews(views: titleField, bodyTextView)
        
        titleField.frame = CGRect(x: 12, y: 120, width: view.width - 24, height: 44)
        bodyTextView.frame = CGRect(x: 8, y: titleField.bottom + 8, width: view.width - 16, height: view.bottom - 220)
    }
}
