//
//  AddRecordTVC.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 07/03/21.
//

import UIKit

class AddRecordTVC: UITableViewCell {

    @IBOutlet weak var recordNameLbl: UILabel!
    @IBOutlet weak var recordValueTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(for index: Int) {
        DispatchQueue.main.async {[weak self] in
            self?.recordNameLbl.text = Constants.RecordNames[index]
        }
    }
    
    func updateCell(for index: Int, with record: RecordData) {
        DispatchQueue.main.async {[weak self] in
            switch index {
            case 0:
                self?.recordValueTextField.text = String(record.id)
            case 1:
                self?.recordValueTextField.text = record.first_name
            case 2:
                self?.recordValueTextField.text = record.last_name
            case 3:
                self?.recordValueTextField.text = record.email
            default:
                break
            }
        }
    }

}
