//
//  NetworkingUtility.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 22/07/20.
//  Copyright © 2020 Utkarsh Sehgal. All rights reserved.
//

import Foundation

//Variable for base url
public var BASE_API_URL: String {
    if let baseUrl = Utility.infoForKey(Constants.ConfigKeys.baseApiUrl) {
        return baseUrl
    }
    return ""
}

//This enum will be used to get api type
public enum Methods: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

//Struct will cntent header keys
struct API_HEADER {
    static let COOKIE = "Cookie"
}

//API Error constants
struct APIError {
    static let invalidRequest = "Invalid request"
    static let unsupportedData = "Unsupported Data"
}
