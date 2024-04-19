//
//  String+Ext.swift
//  QuickNote
//
//  Created by Ruchira  on 19/04/24.
//

import Foundation

extension String {
    
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
