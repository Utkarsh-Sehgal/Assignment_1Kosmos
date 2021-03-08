//
//  ImageSource.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 06/03/21.
//

import Foundation
import UIKit

class ImageSource {
    public func loadImage(at index: Int) -> DataLoadOperation? {
        if (0..<DataRecords.records.count).contains(index) {
            return DataLoadOperation(DataRecords.records[index].avatar, index: index)
        }
        return .none
    }
}

class DataLoadOperation: Operation {
    var avatarImage: UIImage?
    var loadingCompleteHandler: ((UIImage) ->Void)?
    
    private let avatarUrl: String
    private let imageIndex: Int
    private var _avatarImage: UIImage = UIImage()
    
    init(_ avatarImageUrl: String, index: Int) {
        avatarUrl = avatarImageUrl
        imageIndex = index
    }
    
    override func main() {
        if isCancelled { return }
        if let url = URL(string: avatarUrl) {
            do {
                let data = try Data.init(contentsOf: url)
                if let image = UIImage(data: data) {
                    _avatarImage = Utility.resizeImage(image: image, newWidth: 128)
                }
            } catch {
                let pathComponent = "fileName\(imageIndex+1).png"
                let directoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL: URL = directoryURL.appendingPathComponent(pathComponent)
                do {
                    let data = try Data.init(contentsOf: fileURL)
                    if let image = UIImage(data: data) {
                        _avatarImage = Utility.resizeImage(image: image, newWidth: 128)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        if isCancelled { return }
        avatarImage = _avatarImage
        if let loadingCompleteHandler = loadingCompleteHandler {
            DispatchQueue.main.async {[unowned self] in
                loadingCompleteHandler(self._avatarImage)
            }
        }
    }
}


