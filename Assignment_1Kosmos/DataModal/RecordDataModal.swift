//
//  RecordDataModal.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 06/03/21.
//

import Foundation
import UIKit
import CoreData

struct RecordDataModal: Codable {
    var data: [RecordData]
}

struct RecordData: Codable {
    var id: Int
    var email: String
    var first_name: String
    var last_name: String
    var avatar: String
}

struct RecordsResponse: Codable {
    var data: [RecordData]
    
    init(from decoder: Decoder) throws {
        let response = try RecordDataModal(from: decoder)
        data = response.data
        DataRecords.records.append(contentsOf: response.data)
        saveResponseLocally()
    }
    
    init(records: [RecordData]) {
        data = records
        saveResponseLocally()
    }
    
    private func saveResponseLocally() {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            for record in data {
                let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Records", into: context)
                //DataRecords.managedObjects.append(newRecord)
                newRecord.setValue(record.id, forKey: "id")
                newRecord.setValue(record.email, forKey: "email")
                newRecord.setValue(record.first_name, forKey: "firstName")
                newRecord.setValue(record.last_name, forKey: "lastName")
                newRecord.setValue(record.avatar, forKey: "avatar")
            }
            do {
                try context.save()
                print("Success")
            } catch {
                print("Error saving: \(error)")
            }
        }
    }
}

class DataRecords {
    static var records = [RecordData]()
    static var managedObjects = [NSManagedObject]()
}
