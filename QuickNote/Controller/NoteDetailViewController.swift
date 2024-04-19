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
    
    /// The note to be displayed and edited by this view controller.
    var note: QuickNote?
    
    /// The reference to the application's delegate.
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        
        if let note = note {
            titleField.text = note.title
            bodyTextView.attributedText = note.body.getAttributedBodyText()
        }
        
        bodyTextView.delegate = self
        titleField.delegate = self
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

/**
   Extension of `NoteDetailViewController` conforming to `UITextViewDelegate` and `UITextFieldDelegate`.
   It provides implementations for handling text field and text view editing events.
*/

extension NoteDetailViewController: UITextViewDelegate, UITextFieldDelegate {
    
    /**
    Delegate method called when editing of a text field ends.
    - Parameter textField: The text field that ended editing.
    */
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignFirstResponder()
        guard let note = self.note else { return }
        if textField == titleField && titleField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != note.title {
            let managedContext = appDelegate.persistentContainer.viewContext
            note.title = titleField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                fatalError("\(error.userInfo)")
            }
        }
    }
    
    /**
    Delegate method called when editing of a text view ends.
    - Parameter textView: The text view that ended editing.
    */
    
    func textViewDidEndEditing(_ textView: UITextView) {
        resignFirstResponder()
        guard let note = self.note else { return }
        if textView == bodyTextView && bodyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) != note.body {
            let managedContext = appDelegate.persistentContainer.viewContext
            note.body = bodyTextView.text
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                fatalError("\(error.userInfo)")
            }
        }
    }
}

