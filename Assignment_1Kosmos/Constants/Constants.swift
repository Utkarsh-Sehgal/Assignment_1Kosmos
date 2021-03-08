//
//  Constants.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 06/03/21.
//

import Foundation
import UIKit

struct Constants {
    /// Config file keys constants as defined in info.plist 
    struct ConfigKeys {
        static let baseApiUrl = "BASE_API_URL"
    }
    
    /// Main screen bounds
    struct ScreenBounds {
        static let screen_Width = UIScreen.main.bounds.size.width
        static let screen_Height = UIScreen.main.bounds.size.height
    }
    
    static let RecordNames = ["ID", "First Name", "Last Name", "Email Id"]
}
