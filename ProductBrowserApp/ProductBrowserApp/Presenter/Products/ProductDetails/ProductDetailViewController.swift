//
//  ProductDetailViewController.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 18.05.25.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var presenter: ProductDetailPresenterProtocol?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupCollectionView()
        setupFavoriteButton()
        presenter?.viewDidLoad()
    }
    
    private func setupCollectionView(){
        let nib = UINib(nibName: "ImageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier:"ImageCell")
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: collectionView.frame.width, height: 250)
        collectionView.collectionViewLayout = layout
    }
    
    private func setupFavoriteButton(){
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        presenter?.toggleFavorite()
    }
}

extension ProductDetailViewController: ProductDetailView {
    func display(product: ProductItem){
        priceLabel.text = product.price
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        favoriteButton.isSelected = product.isFavorite
        collectionView.reloadData()
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return presenter?.imagesCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell, let url = presenter?.getImage(at: indexPath.row) else {
            return UICollectionViewCell()
        }
        cell.configure(url)
        return cell
    }
}
