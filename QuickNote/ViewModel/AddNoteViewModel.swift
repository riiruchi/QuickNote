//
//  AddNoteViewModel.swift
//  QuickNote
//
//  Created by Ruchira  on 18/04/24.
//
import Foundation
import UIKit

class AddNoteViewModel {
    
    func saveNote(title: String, body: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try CoreDataManager.shared.saveNote(title: title, body: body)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

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
