//
//  Identifiers.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 06/03/20.
//  Copyright © 2020 Utkarsh Sehgal. All rights reserved.
//

import Foundation

/// Storyboard Identifiers
enum Storyboard: String {
    case main = "Main"
}

/// View Controller Identifiers
enum ControllerIdentifiers: String {
    case recordListVC = "RecordListVC"
    case addRecordVC = "AddRecordVC"
}

/// Table and Collection View cell identifiers
struct CellIdentifiers {
    static let recordsCVC = "RecordsCVC"
    static let addRecordTVC = "AddRecordTVC"
}

enum CustomViews {
    static let profileImageSourceSelectionView = "ProfileImageSourceSelectionView"
}
