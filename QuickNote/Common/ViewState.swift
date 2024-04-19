//
//  ViewState.swift
//  QuickNote
//
//  Created by Ruchira  on 19/04/24.
//

import Foundation

/*
Enum representing different states of a view.
- `empty`: Indicates that the view is in an empty state.
- `loading`: Indicates that the view is currently loading data.
- `ready(T)`: Indicates that the view is ready to display the provided data of type T.
- `error(Error)`: Indicates that the view encountered an error while loading data.

This enum provides utility methods to determine the current state of the view:
- `isLoading`: Returns true if the view is in a loading state, false otherwise.
*/

enum ViewState<T> {
    case empty
    case loading
    case ready(T)
    case error(Error)

    var isLoading: Bool {
        switch self {
        case .loading : return true
        default: return false
        }
    }
}
