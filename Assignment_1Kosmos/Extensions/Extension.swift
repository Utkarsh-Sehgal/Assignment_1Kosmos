//
//  Extension.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 06/03/21.
//

import Foundation

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

