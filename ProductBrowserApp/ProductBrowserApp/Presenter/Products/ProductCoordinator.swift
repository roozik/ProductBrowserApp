//
//  ProductCoordinator.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import UIKit

final class ProductCoordinator: Coordinator {
    var navigationController: UINavigationController = UINavigationController()

    private let repository = DataRepository(apiDataSoure: ApiDataSource(networkService: NetworkService()), localDataSource: UserDefaultsLocalDataSource())

    func start() {
        let productListVC = ProductListViewController()
        let presenter = ProductListPresenter(repository: repository, productListView: productListVC, coordinator: self)
        productListVC.presenter = presenter
        navigationController.viewControllers = [productListVC]
    }

    func showProductDetail(for product: ProductItem) {
        let detailVC = ProductDetailViewController(nibName: "ProductDetailViewController", bundle: .main)
        let presenter = ProductDetailPresenter(view: detailVC, product: product, repository: repository)
        detailVC.presenter = presenter
        navigationController.pushViewController(detailVC, animated: true)
    }
}
