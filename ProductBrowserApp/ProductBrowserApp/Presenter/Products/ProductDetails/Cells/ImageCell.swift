//
//  ImageCell.swift
//  YoUser
//
//  Created by Ruzanna on 24.07.24.
//

import UIKit
import Kingfisher

final class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    
    func configure(_ imageURL: URL) {
        productImageView.kf.setImage(with: imageURL)
    }
}
