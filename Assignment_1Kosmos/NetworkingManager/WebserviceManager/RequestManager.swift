//
//  RequestManager.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 22/07/20.
//  Copyright © 2020 Utkarsh Sehgal. All rights reserved.
//

import Foundation
import UIKit

/// Request Protocol
public protocol Request {
    var baseURL: String { get }
    var path: String { get }
    var method: Methods { get }
    var parameters: Any? { get }
    var headers: [[String: String]] { get }
    var queryParam: [URLQueryItem]? { get }
}
//types of APIs request
public enum APIRequest {
    case fetchRecords(pageNumber: Int)
}

// Getters for all the parameters required for building an API request
extension APIRequest: Request {
    
    public var queryParam: [URLQueryItem]? {
        switch self {
        case .fetchRecords(let pageNumber):
            return [URLQueryItem(name: "page", value: String(pageNumber))]
        }
    }
    
    public var baseURL: String {
        switch self {
        case .fetchRecords:
            return BASE_API_URL
        }
    }
    
    public var path: String {
        switch self {
        case .fetchRecords:
            return "/api/users"
        }
    }
    
    public var method: Methods {
        switch self {
        case .fetchRecords:
            return .get
        }
    }
    
    public var parameters: Any? {
        switch self {
        default:
            return nil
        }
    }
    
    public var headers: [[String : String]] {
        switch self {
        default:
            return [[API_HEADER.COOKIE:"__cfduid=d1ba142447a9c6606c22a004fcce47d991615018485"]]
        }
    }
}
