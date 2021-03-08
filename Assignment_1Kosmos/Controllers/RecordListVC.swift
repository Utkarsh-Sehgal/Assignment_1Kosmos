//
//  ViewController.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 05/03/21.
//

import UIKit

class RecordListVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var recordsCollectionView: UICollectionView!
    
    //MARK: Properties
    /// opteration queue instance
    let loadingQueue = OperationQueue()
    /// array to store all the data load operations being performed
    var loadingOperations: [IndexPath: DataLoadOperation] = [:]
    /// image source instance to create operations for image downloading
    var imageSource = ImageSource()
    /// records view model lazy instance to manage records apis for fetching records
    private lazy var recordsViewModal: RecordsViewModel = {
        return RecordsViewModel()
    }()
    
    //MARK: View controller life cycle method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRecords()
    }
    
    //MARK: IBAction(s)
    @IBAction func addRecordAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            if let addRecordVC = self.instantiateController(on: .main, withIdentifier: .addRecordVC) as? AddRecordVC {
                addRecordVC.recordAction = .addRecord
                self.navigationController?.pushViewController(addRecordVC, animated: true)
            }
        }
    }
    
    //MARK: Helper fucntions
    private func fetchRecords() {
        recordsViewModal.fetchRecords { [unowned self] (isSuccess, message) in
            if isSuccess {
                self.reloadRecords()
            } else {
                print(message)
            }
        }
    }
    
    private func reloadRecords() {
        DispatchQueue.main.async { [weak self] in
            self?.recordsCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate and Data source
extension RecordListVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DataRecords.records.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.recordsCVC, for: indexPath) as? RecordsCVC {
            cell.configureCell(for: indexPath.item)
            cell.layoutIfNeeded()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Constants.ScreenBounds.screen_Width
        let height = (collectionView.frame.height - 90)/10
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? RecordsCVC else { return }
        // How should the operation update the cell once the data has been loaded?
        let updateCellClosure: (UIImage?) -> () = { [weak self] avatarImage in
            guard let self = self else {
                return
            }
            if let avatarImage = avatarImage {
                cell.displayAvatar(image: avatarImage)
                self.loadingOperations.removeValue(forKey: indexPath)
            }
        }
        // Try to find an existing data loader
        if let dataLoader = loadingOperations[indexPath] {
            // Has the data already been loaded?
            if let avatarImage = dataLoader.avatarImage {
                cell.displayAvatar(image: avatarImage)
                self.loadingOperations.removeValue(forKey: indexPath)
            } else {
                // No data loaded yet, so add the completion closure to update the cell
                // once the data arrives
                dataLoader.loadingCompleteHandler = updateCellClosure
            }
        } else {
            // Need to create a data loaded for this index path
            if let dataLoader = imageSource.loadImage(at: indexPath.item) {
                // Provide the completion closure, and kick off the loading operation
                dataLoader.loadingCompleteHandler = updateCellClosure
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // If there's a data loader for this index path we don't need it any more.
        // Cancel and dispose
        if let dataLoader = loadingOperations[indexPath] {
          dataLoader.cancel()
          loadingOperations.removeValue(forKey: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if let addRecordVC = self.instantiateController(on: .main, withIdentifier: .addRecordVC) as? AddRecordVC {
                addRecordVC.firstName = DataRecords.records[indexPath.item].first_name
                addRecordVC.lastname = DataRecords.records[indexPath.item].last_name
                addRecordVC.avatarUrlString = DataRecords.records[indexPath.item].avatar
                addRecordVC.email = DataRecords.records[indexPath.item].email
                addRecordVC.id = String(DataRecords.records[indexPath.item].id)
                addRecordVC.index = indexPath.item
                addRecordVC.recordAction = .editRecord
                self.navigationController?.pushViewController(addRecordVC, animated: true)
            }
        }
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension RecordListVC: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = loadingOperations[indexPath] {
                continue
            }
            if let dataLoader = imageSource.loadImage(at: indexPath.item) {
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataLoader = loadingOperations[indexPath] {
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
}
