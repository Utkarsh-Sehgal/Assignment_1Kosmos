//
//  RecordViewModel.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 05/03/21.
//

import Foundation
import CoreData
import UIKit

typealias CompletionHandler = (_ isSuccess: Bool, _ message: String)->()

class RecordsViewModel {
    /// Router Object
    private let router = Router<APIRequest>()
    
    func fetchRecords(completion: @escaping CompletionHandler) {
        DataRecords.records.removeAll()
        self.fetchValues()
        //if no data available locally fetch from url
        if DataRecords.records.count == 0 {
            for i in 1...2 {
                router.request(.fetchRecords(pageNumber: i)) { (result) in
                    switch result {
                    case .success(let response):
                        self.parse(response: response, completion: completion)
                    case .failure(_):
                        completion(false, "Fetch failed")
                    }
                }
            }
        } else {
            completion(true, "Data exists in local db")
        }
    }
    
    private func parse(response: String?, completion: @escaping CompletionHandler) {
        if let response = response, let data = response.data(using: .utf8) {
            do {
                //parse data through codable inherited data modal
                _ = try JSONDecoder().decode(RecordsResponse.self, from: data)
                completion(true, "Data fetched and saved")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Fetch values from core data
    private func fetchValues() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Records")
        do {
            let result = try context.fetch(fetchRequest)
            guard let results = result as? [NSManagedObject] else {
                return
            }
            DataRecords.managedObjects = results
            for data in results {
                if let id = data.value(forKey: "id") as? Int, let email = data.value(forKey: "email") as? String, let firstName = data.value(forKey: "firstName") as? String, let lastName = data.value(forKey: "lastName") as? String, let avatar = data.value(forKey: "avatar") as? String {
                    let record = RecordData(id: id, email: email, first_name: firstName, last_name: lastName, avatar: avatar)
                    DataRecords.records.append(record)
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
