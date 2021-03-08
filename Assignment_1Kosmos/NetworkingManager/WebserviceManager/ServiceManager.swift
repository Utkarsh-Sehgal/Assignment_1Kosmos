//
//  ServiceManager.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 22/07/20.
//  Copyright © 2020 Utkarsh Sehgal. All rights reserved.
//

import Foundation
import UIKit
/// Result
///
/// - success: Success
/// - failure: Failure
enum Result {
    case success(String?)
    case failure(String)
}

/// Protocol for Networking
protocol NetworkRouter: class {
    associatedtype RequestType: Request
    func request(_ request: RequestType, completion: @escaping (Result)->())
    func cancelTask()
}

class Router<RequestType: Request>: NetworkRouter {
    
    private var task: URLSessionTask?
    /// Request call
    func request(_ request: RequestType, completion: @escaping (Result) -> ()) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 10
        let session = URLSession(configuration: configuration)
        guard let urlRequest = self.buildRequest(request) else {
            completion(.failure(APIError.invalidRequest))
            return
        }
        task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error == nil {
                guard let data = data else {
                    completion(.failure(APIError.unsupportedData))
                    return
                }
                self.checkStatus(data: data, completion: completion)
                
            } else {
                print("/error?.localizedDescription",error?.localizedDescription)
                completion(.failure(error?.localizedDescription ?? ""))
            }
        })
        task?.resume()
    }
    
    /// Cancels the previous running task
    func cancelTask() {
        task?.cancel()
    }
}

// MARK: - Building URL Request(s)
extension Router {

    private func buildRequest(_ request: RequestType) -> URLRequest? {
        let baseURLString = request.baseURL
        //adding the query params to request
        var urlComp = URLComponents(string: baseURLString)
        urlComp?.queryItems = request.queryParam
        urlComp?.path = request.path
        guard let url = urlComp?.url else {return nil}
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10
        urlRequest.httpMethod = request.method.rawValue
        /// Adding headers to url request
        request.headers.forEach { (header) in
            header.keys.forEach({ (key) in
                urlRequest.setValue(header[key], forHTTPHeaderField: key)
            })
        }
        if let parameters = request.parameters as? String {
            urlRequest.httpBody = parameters.data(using: .utf8)
        }
        return urlRequest
    }
}

// MARK: - Checks the status for the response received
extension Router {
    private func checkStatus(data: Data, completion: @escaping (Result) -> ()) {
        if let jsonString = String(data: data, encoding: .utf8) {
            completion(.success(jsonString))
        } else {
            completion(.failure("Fetch failed"))
        }
    }
}


