//
//  String+Ext.swift
//  QuickNote
//
//  Created by Ruchira  on 19/04/24.
//

import Foundation

/*
 Extension for String:
 - This extension provides functionality to convert a plain text string into an attributed string with HTML formatting.
*/

extension String {
    
    /*
    getAttributedBodyText():
    - Converts the plain text string into an NSAttributedString with HTML formatting.
    - This method replaces newline characters with <br> tags to maintain line breaks.
    - It handles plain text without <html><body></body></html> tags.
    - Returns: An optional NSAttributedString representing the formatted text.
    */
    
    func getAttributedBodyText() -> NSAttributedString? {
        
        // works even without <html><body> </body></html> tags, BTW
        guard let data = self.replacingOccurrences(of: "\n", with: "<br>").data(using: String.Encoding.unicode) else {
            return nil
        }
        let attrStr = try? NSAttributedString( // do catch
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
                
        return attrStr
    }
}
