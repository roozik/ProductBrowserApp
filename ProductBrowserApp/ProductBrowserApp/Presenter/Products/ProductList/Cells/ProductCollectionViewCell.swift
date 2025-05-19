//
//  ProductCollectionViewCell.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 18.05.25.
//

import UIKit
import Kingfisher

final class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var onFavoriteTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 12
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }
    
    func configure(_ product: ProductItem) {
        priceLabel.text = product.price
        titleLabel.text = product.title
        imageView.kf.setImage(with: product.images.first)
        favoriteButton.isSelected = product.isFavorite
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        onFavoriteTapped?()
    }
}
