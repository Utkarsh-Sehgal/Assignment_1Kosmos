//
//  ProfileImageSourceSelectionView.swift
//  Assignment_1Kosmos
//
//  Created by Utkarsh Sehgal on 05/03/21.
//

import UIKit

/// Image source enum
enum ProfileImageSource {
    case camera
    case gallery
    case removeImage
}

/// Image source selection delegate
protocol ImageSourceSelectionDelegate {
    func optionSelected(option: ProfileImageSource)
}

class ProfileImageSourceSelectionView: UIView {

    //MARK: IBOutlets
    /// content view
    @IBOutlet var contentView: UIView!
    /// popup view which contians the image source selection option
    @IBOutlet weak var bottomPopUp: UIView!
    /// Popup heading label
    @IBOutlet weak var headinLbl: UILabel!
    /// close button
    @IBOutlet weak var closeBtn: UIButton!
    /// camera text label
    @IBOutlet weak var cameraLbl: UILabel!
    /// camera option container view
    @IBOutlet weak var cameraView: UIView!
    /// gallery text label
    @IBOutlet weak var galleryLbl: UILabel!
    /// gallery option container view
    @IBOutlet weak var galleryView: UIView!
    /// gallery option btn
    @IBOutlet weak var galleryBtn: UIButton!
    /// Camera option btn
    @IBOutlet weak var cameraBtn: UIButton!
    /// remove profile image btn
    @IBOutlet weak var removeImageBtn: UIButton!
    
    /// delegate instance handling the image source selection action
    var delegate: ImageSourceSelectionDelegate?
    
    // MARK: - Initializer(s)
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - View LifeCycle Method(s)
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds
        cameraView.layer.cornerRadius = cameraView.frame.height/2
        galleryView.layer.cornerRadius = galleryView.frame.height/2
        bottomPopUp.dropShadow(color: .gray, opacity: 0.8)
        bottomPopUp.roundCorners(with: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 25)
        galleryView.addLineDashedStroke(pattern: [5,5], radius: galleryView.frame.height/2, color: UIColor.gray.cgColor)
        cameraView.addLineDashedStroke(pattern: [5,5], radius: galleryView.frame.height/2, color: UIColor.gray.cgColor)
    }
    
    //MARK: IBActions
    @IBAction func closeAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    /// Gallery option action
    /// - Parameter sender: gallery btn
    @IBAction func galleryBtnAction(_ sender: UIButton) {
        delegate?.optionSelected(option: .gallery)
        self.removeFromSuperview()
    }
    
    /// Camera option action
    /// - Parameter sender: camera btn
    @IBAction func cameraBtnAction(_ sender: UIButton) {
        delegate?.optionSelected(option: .camera)
        self.removeFromSuperview()
    }
    
    /// Remove profile option action
    /// - Parameter sender: Remove profile btn
    @IBAction func removeImageAction(_ sender: UIButton) {
        delegate?.optionSelected(option: .removeImage)
        self.removeFromSuperview()
    }
    
    //MARK: Helper method(s)
    /*
    * Load Nib and set frame/contraint.
    */
    private func commonInit() {
        Bundle.main.loadNibNamed(CustomViews.profileImageSourceSelectionView, owner: self, options: nil)
        addSubview(contentView)
        configureUI()
    }
    
    /// Configure ui based on design
    private func configureUI() {
        galleryView.backgroundColor = .lightGray
        cameraView.backgroundColor = .lightGray
        galleryBtn.setTitleColor(.gray, for: .normal)
        cameraBtn.setTitleColor(.gray, for: .normal)
        headinLbl.text = "Upload Photo"
        cameraLbl.text = "Camera"
        galleryLbl.text = "Gallery"
        cameraLbl.textColor = .gray
        galleryLbl.textColor = .gray
        removeImageBtn.setTitle("Remove Image", for: .normal)
    }
}
