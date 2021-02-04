//
//  LayoutCell.swift
//  Instagrid
//
//  Created by Symbioz on 04/02/2021.
//

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
