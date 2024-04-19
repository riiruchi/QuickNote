//
//  AddNoteViewModel.swift
//  QuickNote
//
//  Created by Ruchira  on 18/04/24.
//
import Foundation
import UIKit

/**
`AddNoteViewModel` manages the business logic related to adding notes within the application.
*/

class AddNoteViewModel {
    
    /**
    Saves a note with the provided title and body.
    - Parameters:
    - title: The title of the note.
    - body: The body text of the note.
    - completion: A closure to be called after the note is saved, indicating the result of the operation.
    - result: A `Result` enum with either a success or failure case.
    */
    
    func saveNote(title: String, body: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try CoreDataManager.shared.saveNote(title: title, body: body)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    /**
    Saves a note with the provided title and attributed text.
    - Parameters:
    - title: The title of the note.
    - attributedText: The attributed text of the note body, possibly containing formatting.
    - completion: A closure to be called after the note is saved, indicating the result of the operation.
    - result: A `Result` enum with either a success or failure case.
    */
    
    func saveNoteWithAttributedText(title: String, attributedText: NSAttributedString, completion: @escaping (Result<Void, Error>) -> Void) {
        let (formattedText, _) = parseAttributedText(attributedText)
        do {
            try CoreDataManager.shared.saveNote(title: title, body: formattedText)
            // Handle checklistItems if needed
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    /**
    Parses the given attributed text to extract formatting information.
    - Parameter attributedText: The attributed text to be parsed.
    - Returns: A tuple containing the formatted text and any checklist items extracted from the attributed text.
    */
    
    func parseAttributedText(_ attributedText: NSAttributedString) -> (String, [String]) {
        var formattedText = ""
        var checklistItems: [String] = []
        
        attributedText.enumerateAttributes(in: NSRange(location: 0, length: attributedText.length),
                                           options: []) { attributes, range, _ in
            let font = attributes[.font] as? UIFont
            
            // Check for bold or italic
            let isBold = font?.fontDescriptor.symbolicTraits.contains(.traitBold) ?? false
            let isItalic = font?.fontDescriptor.symbolicTraits.contains(.traitItalic) ?? false
            
            // Append text with formatting information
            var text = attributedText.attributedSubstring(from: range).string
            if isBold {
                text = "<b>\(text)</b>"
            }
            if isItalic {
                text = "<i>\(text)</i>"
            }
            formattedText += text
            
            // Check for checklist items
            if let bullet = attributes[.attachment] as? NSTextAttachment,
               let image = bullet.image, image.size == CGSize(width: 12, height: 12) {
                checklistItems.append(text)
            }
        }
        return (formattedText, checklistItems)
    }
}
