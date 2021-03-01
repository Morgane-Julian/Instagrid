//
//  Extensions.swift
//  Instagrid
//
//  Created by Symbioz on 01/03/2021.
//

import UIKit

//MARK: Extension of UIVew for transform collectionView to UIImage
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

