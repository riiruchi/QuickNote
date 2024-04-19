//
//  UIView+Ext.swift
//  QuickNote
//
//  Created by Ruchira  on 17/04/24.
//
import UIKit
    
    /*
    Extension for UIView to provide additional properties and methods.
    */

    extension UIView {
        
        /**
        Retrieves the width of the view.
        - Returns: The width of the view.
        */
        
        var width: CGFloat {
            frame.size.width
        }
        
        /**
        Retrieves the height of the view.
        - Returns: The height of the view.
        */
        
        var height: CGFloat {
            frame.size.height
        }

        /**
        Retrieves the left edge position of the view.
        - Returns: The x-coordinate of the left edge of the view.
        */
        
        var left: CGFloat {
            frame.origin.x
        }

        /**
        Retrieves the right edge position of the view.
        - Returns: The x-coordinate of the right edge of the view.
        */
        
        var right: CGFloat {
            left + width
        }

        /**
        Retrieves the top edge position of the view.
        - Returns: The y-coordinate of the top edge of the view.
        */
        
        var top: CGFloat {
            frame.origin.y
        }

        /**
        Retrieves the bottom edge position of the view.
        - Returns: The y-coordinate of the bottom edge of the view.
        */
        
        var bottom: CGFloat {
            top + height
        }
        
        /**
        Adds multiple subviews to the current view.
        - Parameter views: The views to be added as subviews.
        */
        
        func addSubViews(views: UIView...) {
            for view in views {
                self.addSubview(view)
            }
        }
    }
