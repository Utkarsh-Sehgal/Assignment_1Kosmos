//
//  RecordsCVC.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 06/03/21.
//

import UIKit

class RecordsCVC: UICollectionViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func prepareForReuse() {
        DispatchQueue.main.async { [weak self] in
            self?.avatar.image = nil
        }
    }
    
    func configureCell(for index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.nameLbl.text = DataRecords.records[index].first_name + " " + DataRecords.records[index].last_name
        }
    }
    
    func displayAvatar(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.avatar.backgroundColor = .clear
            self?.avatar.image = image
        }
    }
}
