//
//  LayoutCell.swift
//  Instagrid
//
// Created by Julian Morgane on 22/01/2021.//

import UIKit

class LayoutCell: UICollectionViewCell {
    @IBOutlet weak var addPhotoImg: UIImageView!
    @IBOutlet weak var selectedPhotoImg: UIImageView!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.init(named: "InstaWhite")
        self.layer.borderColor = UIColor.init(named: "InstaDarkBlue")?.cgColor
        self.layer.borderWidth = 5
    }
}
