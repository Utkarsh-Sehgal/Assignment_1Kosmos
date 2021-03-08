//
//  BaseVC.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 07/03/21.
//

import UIKit

class BaseVC: UIViewController {

    //MARK: View controller life cycle method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Instantiate controller
    ///
    /// - Parameters:
    ///   - storyboard: StoryBoard Name
    ///   - identifier: Identifier of controller
    /// - Returns: Instantiated Controller
    func instantiateController(on storyboard: Storyboard, withIdentifier identifier: ControllerIdentifiers) -> UIViewController {
        let currentStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let controller = currentStoryboard.instantiateViewController(withIdentifier: identifier.rawValue)
        return controller
    }
}
