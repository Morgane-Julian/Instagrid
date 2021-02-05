//
//  ViewController.swift
//  Instagrid
//
//  Created by Julian Morgane on 22/01/2021.
//

import UIKit


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var swipeView: UIView!
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
    
    
    // MARK: Swipe to share
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {

        let activityController = UIActivityViewController(activityItems: [self.selectedPhoto0], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
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
    // IBAction appelée quand on clique sur le bouton d'une cell de la collectionView
    @IBAction func didTapImgButton(_ sender: UIButton) {
        // On récupère l'indexPath de la cellule dans lequel le bouton a été cliqué
        let point = sender.convert(CGPoint.zero, to:self.layoutCollectionView)
        if let indexPath = self.layoutCollectionView.indexPathForItem(at: point) {
            // On garde l'indexPath sur lequel on a tapé pour pouvoir l'utiliser dans la methode didFinishPickingMediaWithInfo
            self.selectedIndexPath = indexPath
        }
        
        let imgController = UIImagePickerController()
        imgController.sourceType = .photoLibrary
        imgController.delegate = self
        imgController.allowsEditing = true
        self.present(imgController, animated: true, completion: nil)
    }
    
    // Méthode que l'on a créée pour afficher le layoutMode selectionné parmi les 3 proposés
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
    // Elle est appelée une seule fois et nous demande combien de cellules il y a en tout dans la liste à afficher
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.layoutMode {
        case LayoutMode.layoutMode1, LayoutMode.layoutMode2 :
            return 3
        case LayoutMode.layoutMode3 :
            return 4
        }
    }
    
    // Méthode appelé par le systeme pour redessiner la collectionView
    // Elle est appelée par le système autant de fois qu'il y a des cellules à afficher
    // Elle pase en param l'indexPath qui nous permet d'identifier la cellule à dessiner
    // On retourne à la fin de la méthode obligatoirement la cellule personalisée en fonction de l'indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayoutCell", for: indexPath) as! LayoutCell
            if indexPath.item == 0 {
                cell.addPhotoImg.isHidden = self.selectedPhoto0 != nil ? true : false
                cell.selectedPhotoImg.image = self.selectedPhoto0
            } else if indexPath.item == 1 {
                cell.selectedPhotoImg.image = self.selectedPhoto1
                cell.addPhotoImg.isHidden = self.selectedPhoto1 != nil ? true : false
            } else if indexPath.item == 2 {
                cell.selectedPhotoImg.image = self.selectedPhoto2
                cell.addPhotoImg.isHidden = self.selectedPhoto2 != nil ? true : false
            } else if indexPath.item == 3 {
                cell.selectedPhotoImg.image = self.selectedPhoto3
                cell.addPhotoImg.isHidden = self.selectedPhoto3 != nil ? true : false
            }
            return cell
        }

    // Elles est appelée autant de fois qu'il y a de cellules à afficher, elle passe en param l'indexpath pour identifier la cellule nous devons retourner la taille de la cellule pour l'indexPath demandé.
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
    // Méthode appelé par le system lorsqu'on a selectionné une image dans la bibli
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // On se sert de l'indexPath précédemment selectionné pour choisir dans quel attribut mettre l'image selectionnée dans le picker
        var image: UIImage?
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = img
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = img
        }
        
        if self.selectedIndexPath?.item == 0 {
            self.selectedPhoto0 = image
        } else if self.selectedIndexPath?.item == 1 {
            self.selectedPhoto1 = image
        } else if self.selectedIndexPath?.item == 2 {
            self.selectedPhoto2 = image
        } else if self.selectedIndexPath?.item == 3 {
            self.selectedPhoto3 = image
        }
        
        picker.dismiss(animated: true) {
            self.layoutCollectionView.reloadData()
        }
    }
    
    
    // Methode appelée lorsqu'on a cancel le selection/la bilio
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


