//
//  AddNotesViewController.swift
//  QuickNote
//
//  Created by Ruchira  on 17/04/24.

import UIKit

protocol AddNoteViewControllerDelegate {
    func didFinishAddingNote()
}

class AddNoteViewController: UIViewController {
    
    var delegate: AddNoteViewControllerDelegate?
    private lazy var viewModel = AddNoteViewModel()
    
    // UI elements
    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    private let addChecklistItemTextField = UITextField()
    private let checklistTableView = UITableView()
    
    // Data model
    private var checklistItems: [String] = []
    
    // Custom view for additional options
    private let customOptionsView = UIView()
    private let checklistButton = UIButton(type: .system)
    private let boldButton = UIButton(type: .system)
    private let italicButton = UIButton(type: .system)
    
    // Constraints for customOptionsView
    private var customOptionsViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Add Note"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        
        setupCustomOptionsView()
        setupUI()
        registerForKeyboardNotifications()
        
        // Set font for titleTextField
        titleTextField.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        // Set font for descriptionTextView
        descriptionTextView.font = UIFont.systemFont(ofSize: 18)
        
    }
    
    private func setupUI() {
        // Title text field
        titleTextField.placeholder = "Title"
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleTextField)
        
        // Description text view
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.text = "" // Ensure the initial text is empty
        descriptionTextView.textColor = UIColor.lightGray // Set placeholder color
        descriptionTextView.text = "Description" // Set placeholder text
        descriptionTextView.delegate = self // Set delegate to handle placeholder behavior
        view.addSubview(descriptionTextView)
        
        // Set constraints
        NSLayoutConstraint.activate([
            // Title text field constraints
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Description text view constraints
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.bottomAnchor.constraint(equalTo: customOptionsView.topAnchor, constant: -20)
        ])
    }
    
    private func setupCustomOptionsView() {
            // Custom options view
            customOptionsView.backgroundColor = .tertiarySystemBackground
            customOptionsView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(customOptionsView)
            
            // Checklist button
            let checklistImage = UIImage(systemName: "checkmark.circle") // Replace "checkmark.circle" with the SF Symbol name you want to use
            checklistButton.setImage(checklistImage, for: .normal)
            checklistButton.translatesAutoresizingMaskIntoConstraints = false
            checklistButton.addTarget(self, action: #selector(addChecklistItem), for: .touchUpInside)
            
            // Bold button
            let boldImage = UIImage(systemName: "bold") // Replace "bold" with the SF Symbol name you want to use
            boldButton.setImage(boldImage, for: .normal)
            boldButton.translatesAutoresizingMaskIntoConstraints = false
            boldButton.addTarget(self, action: #selector(boldButtonTapped), for: .touchUpInside)
            
            // Italic button
            let italicImage = UIImage(systemName: "italic") // Replace "italic" with the SF Symbol name you want to use
            italicButton.setImage(italicImage, for: .normal)
            italicButton.translatesAutoresizingMaskIntoConstraints = false
            italicButton.addTarget(self, action: #selector(italicButtonTapped), for: .touchUpInside)

            
            // Stack view for buttons
            let buttonsStackView = UIStackView(arrangedSubviews: [checklistButton, boldButton, italicButton])
            buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
            buttonsStackView.spacing = 20 // Adjust the spacing between buttons
            buttonsStackView.distribution = .fillEqually // Make buttons equally spaced
            customOptionsView.addSubview(buttonsStackView)
            
            // Set constraints
            NSLayoutConstraint.activate([
                // Custom options view constraints
                customOptionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                customOptionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                customOptionsView.heightAnchor.constraint(equalToConstant: 50),
                
                // Stack view constraints
                buttonsStackView.leadingAnchor.constraint(equalTo: customOptionsView.leadingAnchor, constant: 20),
                buttonsStackView.trailingAnchor.constraint(equalTo: customOptionsView.trailingAnchor, constant: -20),
                buttonsStackView.topAnchor.constraint(equalTo: customOptionsView.topAnchor),
                buttonsStackView.bottomAnchor.constraint(equalTo: customOptionsView.bottomAnchor)
            ])
            
            // Bottom constraint will be adjusted based on keyboard appearance
            customOptionsViewBottomConstraint = customOptionsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            customOptionsViewBottomConstraint.isActive = true
        }
    
    @objc private func boldButtonTapped() {
        applyTextStyle(isBold: true)
    }
    
    @objc private func italicButtonTapped() {
        applyTextStyle(isBold: false, isItalic: true)
    }
    
    private func applyTextStyle(isBold: Bool = false, isItalic: Bool = false) {
        guard let selectedRange = descriptionTextView.selectedTextRange else { return }
        guard let selectedText = descriptionTextView.text(in: selectedRange), !selectedText.isEmpty else { return }
        
        let attributedString = NSMutableAttributedString(string: selectedText, attributes: descriptionTextView.typingAttributes)
        
        // Apply bold style if needed
        if isBold {
            let boldFont = UIFont.boldSystemFont(ofSize: descriptionTextView.font?.pointSize ?? UIFont.systemFontSize)
            attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: selectedText.count))
        }
        
        // Apply italic style if needed
        if isItalic {
            let italicFont = UIFont.italicSystemFont(ofSize: descriptionTextView.font?.pointSize ?? UIFont.systemFontSize)
            attributedString.addAttribute(.font,
                                          value: italicFont,
                                          range: NSRange(location: 0,
                                          length: selectedText.count))
        }
        
        // Replace the selected text with the styled text
        descriptionTextView.textStorage.replaceCharacters(in: descriptionTextView.selectedRange,
                                                          with: attributedString)
    }
    
    @objc private func addChecklistItem() {
        // Append the round checkbox icon to the description text view
        if let currentText = descriptionTextView.text, !currentText.isEmpty {
            descriptionTextView.text += "\n○ " // Use round bullet character
        } else {
            descriptionTextView.text = "○ " // Use round bullet character
        }
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        customOptionsViewBottomConstraint.constant = -keyboardHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        customOptionsViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didTapSaveButton() {
        guard let title = titleTextField.text, !title.isEmpty else {
           
            let alertController = UIAlertController(title: "Fields Required", message: "Please enter a title and body for your note!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)

            return
        }

        guard let attributedText = descriptionTextView.attributedText else {
            // If no attributed text, save with plain text
            let plainText = descriptionTextView.text ?? ""
            viewModel.saveNote(title: title, body: plainText, completion: handleSaveCompletion)
            return
        }

        viewModel.saveNoteWithAttributedText(title: title, attributedText: attributedText, completion: handleSaveCompletion)
    }
    
    private func handleSaveCompletion(result: Result<Void, Error>) {
        switch result {
        case .success:
            DispatchQueue.main.async {
                self.delegate?.didFinishAddingNote()
                let alertController = UIAlertController(title: "Note Saved", message: "Note has been saved successfully!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
                    guard let self = self else { return }
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        case .failure(let error):
            // Handle error
            print("Error saving note: \(error)")
        }
    }
}

extension AddNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
}
