//
//  AddRecordVC.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 07/03/21.
//

import UIKit
import AssetsLibrary
import CoreData

//enum to confirm the record updation or addtion action
enum RecordAction {
    case editRecord
    case addRecord
}

class AddRecordVC: BaseVC {
    //MARK: IBOutlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var recordsTableview: UITableView!
    
    //MARK: Properties
    var recordAction: RecordAction = .addRecord
    /// image source selection custom view
    var profileImageSelector: ProfileImageSourceSelectionView?
    var avatarUrlString = ""
    var firstName = ""
    var id = ""
    var email = ""
    var lastname = ""
    var index = -1
    
    //MARK: View controller life cycle method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        if recordAction == .editRecord {
            configureUI()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.width/2
    }
    
    //MARK: IBAction(s)
    @IBAction func addImageAction(_ sender: UIButton) {
        // add the custom profile image source selection view and animate it from the bottom
        profileImageSelector = ProfileImageSourceSelectionView(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.maxY, width: self.view.frame.width, height: self.view.frame.height))
        profileImageSelector?.delegate = self
        if let btview = profileImageSelector {
            self.view.addSubview(btview)
            UIView.animate(withDuration: 0.3) {
                btview.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height)
            }
        }
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        getRecordValues()
        //if edit record then update the managed context for geiven index else add a new object to the context
        if recordAction == .editRecord {
            DataRecords.managedObjects[index].setValue(Int(id) ?? 0, forKey: "id")
            DataRecords.managedObjects[index].setValue(email, forKey: "email")
            DataRecords.managedObjects[index].setValue(firstName, forKey: "firstName")
            DataRecords.managedObjects[index].setValue(lastname, forKey: "lastName")
            DataRecords.managedObjects[index].setValue(avatarUrlString, forKey: "avatar")
            do {
                try context.save()
               }
            catch {
                print("Saving Core Data Failed: \(error)")
            }
        } else {
            let _ = RecordsResponse(records: [RecordData(id: Int(id) ?? 0, email: email, first_name: firstName, last_name: lastname, avatar: avatarUrlString)])
        }
        DispatchQueue.main.async {[unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        DispatchQueue.main.async {[unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: Helper fucntions
    private func getRecordValues() {
        for index in 0..<Constants.RecordNames.count {
            if let cell = recordsTableview.cellForRow(at: IndexPath(row: index, section: 0)) as? AddRecordTVC {
                switch index {
                case 0:
                    id = cell.recordValueTextField.text ?? ""
                case 1:
                    firstName = cell.recordValueTextField.text ?? ""
                case 2:
                    lastname = cell.recordValueTextField.text ?? ""
                case 3:
                    email = cell.recordValueTextField.text ?? ""
                default:
                    break
                }
            }
        }
    }
    
    private func configureUI() {
        if let url = URL(string: avatarUrlString) {
            do {
                let data = try Data.init(contentsOf: url)
                if let image = UIImage(data: data) {
                    self.profileImage.image = image
                }
            } catch {
                let pathComponent = "fileName\(index+1).png"
                let directoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL: URL = directoryURL.appendingPathComponent(pathComponent)
                do {
                    let data = try Data.init(contentsOf: fileURL)
                    if let image = UIImage(data: data) {
                        self.profileImage.image = Utility.resizeImage(image: image, newWidth: 200)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

//MARK: UITableViewDataSource and delegate
extension AddRecordVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.RecordNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.addRecordTVC) as? AddRecordTVC {
            if recordAction == .editRecord {
                cell.updateCell(for: indexPath.row, with: RecordData(id: Int(id) ?? 0, email: email, first_name: firstName, last_name: lastname, avatar: avatarUrlString))
            }
            cell.configureCell(for: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: UIImagePickerControllerDelegate
extension AddRecordVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //save picked image in document directory and save url in core data
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            guard let data = pickedImage.jpegData(compressionQuality: 0.5) ?? pickedImage.pngData() else {
                return
            }
            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                return
            }
            do {
                var path = URL.init(string: "")
                if recordAction == .editRecord {
                    path = directory.appendingPathComponent("fileName\(index+1).png")
                } else {
                    path = directory.appendingPathComponent("fileName\(DataRecords.records.count+1).png")
                }
                if let localPath = path {
                    try data.write(to: localPath)
                    avatarUrlString = localPath.absoluteString
                }
            } catch {
                print(error.localizedDescription)
            }
            
            
            self.profileImage.contentMode = .scaleAspectFill
            self.profileImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}



//MARK: Image source selection delegate methods
extension AddRecordVC: ImageSourceSelectionDelegate {
    func optionSelected(option: ProfileImageSource) {
        switch option {
        case .camera:
            //open camera
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
            }
        case .gallery:
            // open gallery
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
            }
        case .removeImage:
            // remove profile image
            self.profileImage.image = nil
        }
    }
}
