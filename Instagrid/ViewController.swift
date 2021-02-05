//
//  ViewController.swift
//  Instagrid
//
//  Created by Julian Morgane on 22/01/2021.
//

import UIKit


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var layoutCollectionView: UICollectionView!
    @IBOutlet weak var layoutStackView: UIStackView!
    @IBOutlet weak var layout1SelectedImgView: UIImageView!
    @IBOutlet weak var layout2SelectedImgView: UIImageView!
    @IBOutlet weak var layout3SelectedImgView: UIImageView!
    
    var layoutMode = LayoutMode.layoutMode1
    
    var selectedPhoto0 : UIImage?
    var selectedPhoto1 : UIImage?
    var selectedPhoto2 : UIImage?
    var selectedPhoto3 : UIImage?
    
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadLayoutStackView()
        self.layoutCollectionView.layer.borderColor = UIColor.init(named: "InstaDarkBlue")?.cgColor
        self.layoutCollectionView.layer.borderWidth = 10
    }
    
    
    // MARK: Select a layout
    
    @IBAction func touchUpLayout1Btn(_ sender: Any) {
        self.layoutMode = LayoutMode.layoutMode1
        self.reloadLayoutStackView()
    }
    @IBAction func touchUpLayout2Btn(_ sender: Any) {
        self.layoutMode = LayoutMode.layoutMode2
        self.reloadLayoutStackView()
    }
    @IBAction func touchUpLayout3Btn(_ sender: Any) {
        self.layoutMode = LayoutMode.layoutMode3
        self.reloadLayoutStackView()
    }
    
    // MARK: User want add a photo
    
    @IBAction func didTapImgButton(_ sender: UIButton) {
        let imgController = UIImagePickerController()
        imgController.sourceType = .photoLibrary
        imgController.delegate = self
        imgController.allowsEditing = true
        self.present(imgController, animated: true, completion: nil)
        
        let point = sender.convert(CGPoint.zero, to:self.layoutCollectionView)
        if let indexPath = self.layoutCollectionView.indexPathForItem(at: point) {
            self.selectedIndexPath = indexPath
        }
    }
    
    func reloadLayoutStackView() {
        self.layout1SelectedImgView.isHidden = true
        self.layout2SelectedImgView.isHidden = true
        self.layout3SelectedImgView.isHidden = true
        
        self.layoutCollectionView.reloadData()
        
        switch self.layoutMode {
        case .layoutMode1 :
            self.layout1SelectedImgView.isHidden = false
        case .layoutMode2 :
            self.layout2SelectedImgView.isHidden = false
        case .layoutMode3 :
            self.layout3SelectedImgView.isHidden = false
        }
    }
    
    // MARK: CollectionView Protocols
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.layoutMode {
        case LayoutMode.layoutMode1, LayoutMode.layoutMode2 :
            return 3
        case LayoutMode.layoutMode3 :
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayoutCell", for: indexPath) as! LayoutCell
        
        if indexPath.item == 0 {
            cell.selectedPhotoImg.image = self.selectedPhoto0
            cell.addPhotoImg.isHidden = self.selectedPhoto0 != nil ? true : false
        } else if indexPath.item == 1 {
            cell.selectedPhotoImg.image = self.selectedPhoto1
            cell.addPhotoImg.isHidden = self.selectedPhoto0 != nil ? true : false
        } else if indexPath.item == 2 {
            cell.selectedPhotoImg.image = self.selectedPhoto2
            cell.addPhotoImg.isHidden = self.selectedPhoto0 != nil ? true : false
        } else if indexPath.item == 3 {
            cell.selectedPhotoImg.image = self.selectedPhoto3
            cell.addPhotoImg.isHidden = self.selectedPhoto0 != nil ? true : false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = collectionView.frame.size.width / 2
        switch self.layoutMode {
        case LayoutMode.layoutMode1  :
            if indexPath.item == 0 {
                return CGSize.init(width: itemSize * 2, height: itemSize)
            } else {
                return CGSize.init(width: itemSize, height: itemSize)
            }
        case LayoutMode.layoutMode2 :
            if indexPath.item == 2 {
                return CGSize.init(width: itemSize * 2, height: itemSize)
            } else {
                return CGSize.init(width: itemSize, height: itemSize)
            }
        case LayoutMode.layoutMode3 :
            return CGSize.init(width: itemSize, height: itemSize)
        }
    }

    
    // MARK: ImagePicker Protocols
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if ((info[UIImagePickerController.InfoKey.editedImage] as? UIImage) != nil) {
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

 
