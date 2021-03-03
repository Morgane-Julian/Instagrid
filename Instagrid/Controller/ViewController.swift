//
//  ViewController.swift
//  Instagrid
//
//  Created by Julian Morgane on 22/01/2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var layout1Btn: UIButton!
    @IBOutlet weak var layout2Btn: UIButton!
    @IBOutlet weak var layout3Btn: UIButton!
    @IBOutlet weak var swipeToShare: UILabel!
    @IBOutlet weak var arrowLeft: UIImageView!
    @IBOutlet weak var arrowUp: UIImageView!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var layoutCollectionView: UICollectionView!
    @IBOutlet weak var layoutStackView: UIStackView!
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var layoutCollectionViewCenterConstraint: NSLayoutConstraint!
            
    @IBOutlet weak var layoutCollectionViewLandscapeConstraint: NSLayoutConstraint!
    
    var layoutMode : LayoutMode = .layoutMode1
    var selectedPhoto : [UIImage?] = [nil, nil, nil, nil]
    var selectedIndexPath : IndexPath?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutCollectionView.layer.borderColor = UIColor(named: "InstaDarkBlue")?.cgColor
        self.layoutCollectionView.layer.borderWidth = 10
        self.layout1Btn.isSelected = true
    }
    
    //MARK: Orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.layoutCollectionView.reloadData()
        if UIDevice.current.orientation.isLandscape {
            self.swipeToShare.text = "Swipe left to share"
            self.arrowLeft.isHidden = false
            self.swipeGesture.direction = .left
        } else {
            self.swipeToShare.text = "Swipe up to share"
            self.arrowUp.isHidden = false
            self.swipeGesture.direction = .up
        }
    }
    
    // MARK: Swipe to share
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
        
        let translateImage = self.layoutCollectionView.asImage()
        
        if UIDevice.current.orientation.isPortrait {
            self.layoutCollectionViewCenterConstraint.constant = -300
        } else {
            self.layoutCollectionViewLandscapeConstraint.constant = -500
        }
        UIView.animate(withDuration: 1, animations: {
            self.layoutCollectionView.layer.opacity = 0
            self.swipeView.layer.opacity = 0
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            let activityController = UIActivityViewController(activityItems: [translateImage], applicationActivities: nil)
            activityController.completionWithItemsHandler = { (type,completed,items,error) in
                if UIDevice.current.orientation.isPortrait {
                    self.layoutCollectionViewCenterConstraint.constant = 0
                } else {
                    self.layoutCollectionViewLandscapeConstraint.constant = 0
                }
                
                UIView.animate(withDuration: 1) {
                    self.layoutCollectionView.layer.opacity = 1
                    self.swipeView.layer.opacity = 1
                    self.view.layoutIfNeeded()
                }
            }
            self.present(activityController, animated: true, completion: nil)
        })
    }
    
    // MARK: Select a layout
    @IBAction func didTapLayout1Btn(_ sender: UIButton) {
        self.layout1Btn.isSelected = true
        self.layout2Btn.isSelected = false
        self.layout3Btn.isSelected = false
        self.layoutMode = .layoutMode1
        self.layoutCollectionView.reloadData()
    }
    
    @IBAction func didTapLayout2Btn(_ sender: UIButton) {
        self.layout2Btn.isSelected = true
        self.layout1Btn.isSelected = false
        self.layout3Btn.isSelected = false
        self.layoutMode = .layoutMode2
        self.layoutCollectionView.reloadData()
    }
    
    @IBAction func didTapLayout3Btn(_ sender: UIButton) {
        self.layout3Btn.isSelected = true
        self.layout1Btn.isSelected = false
        self.layout2Btn.isSelected = false
        self.layoutMode = .layoutMode3
        self.layoutCollectionView.reloadData()
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        let imgController = UIImagePickerController()
        imgController.sourceType = .photoLibrary
        imgController.delegate = self
        imgController.allowsEditing = true
        self.present(imgController, animated: true, completion: nil)
    }
    
    
    // MARK: CollectionView Protocols
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.layoutMode {
        case .layoutMode1, .layoutMode2 :
            return 3
        case .layoutMode3 :
            return 4
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayoutCell", for: indexPath) as? LayoutCell {
            cell.selectedPhotoImg.image = self.selectedPhoto[indexPath.item]
            cell.addPhotoImg.isHidden = self.selectedPhoto[indexPath.item] != nil ? true : false
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = collectionView.frame.size.width / 2
        switch self.layoutMode {
        case .layoutMode1  :
            if indexPath.item == 0 {
                return CGSize.init(width: itemSize * 2, height: itemSize)
            } else {
                return CGSize.init(width: itemSize, height: itemSize)
            }
        case .layoutMode2 :
            if indexPath.item == 2 {
                return CGSize.init(width: itemSize * 2, height: itemSize)
            } else {
                return CGSize.init(width: itemSize, height: itemSize)
            }
        case .layoutMode3 :
            return CGSize.init(width: itemSize, height: itemSize)
        }
    }
    
    
    // MARK: ImagePicker Protocols
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage?
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = img
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = img
        }
        self.selectedPhoto[selectedIndexPath?.item ?? 0] = image
        picker.dismiss(animated: true) {
            self.layoutCollectionView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



