//
//  ProductListViewController.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import UIKit
import Combine

enum SectionType: Hashable {
  case main
}

final class ProductListViewController: UIViewController {
    
    fileprivate typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ProductItem>
    fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, ProductItem>
    
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Oops, looks like our shelves are empty :( \n\n Come back soon — we're restocking with awesome stuff!"
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private lazy var dataSource = makeDataSource()
    private let refreshControl = UIRefreshControl()
    var presenter: ProductListPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        setupCollectionView()
        setupPlaceholder()
        setupLoader()
        presenter.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.refreshFavoriteStates()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier:"ProductCollectionViewCell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupLoader() {
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .gray
    }
    
    private func setupPlaceholder() {
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func refreshData() {
        presenter.refreshData()
    }
}

extension ProductListViewController: ProductListView {
    func updateData(_ data: DataResult<ProductItem>) {
        placeholderLabel.isHidden = true
        switch data {
        case .loading:
            loadingIndicator.startAnimating()
        case .success(let data):
            loadingIndicator.stopAnimating()
            refreshControl.endRefreshing()
            let isRefreshing = presenter.currentPage == 0
            applySnapshot(products: data, isRefreshing: isRefreshing)
        case .error(let error):
            loadingIndicator.stopAnimating()
            refreshControl.endRefreshing()
            showAlert(message: error?.localizedDescription ?? "Unknown error")
        }
    }
    
    func updateSingleItem(_ item: ProductItem) {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([item])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ProductListViewController {
    private func makeDataSource() -> DataSource {
      return UICollectionViewDiffableDataSource<SectionType, ProductItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, userItem in
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else {
            fatalError()
          }
          cell.configure(userItem)
          cell.onFavoriteTapped = { [weak self] in
              userItem.isFavorite = !userItem.isFavorite
              self?.presenter.toggleFavorite(for: userItem.id)
          }
          return cell
      })
    }
    
    private func applySnapshot(products: [ProductItem], isRefreshing: Bool = false, animatingDifferences: Bool = true) {
        var snapshot = dataSource.snapshot()
        let section = SectionType.main

        if isRefreshing || snapshot.sectionIdentifiers.isEmpty {
            if products.isEmpty {
                placeholderLabel.isHidden = false
                return
            }
            snapshot = Snapshot()
            snapshot.appendSections([section])
            snapshot.appendItems(products, toSection: section)
            dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        } else {
            if !products.isEmpty {
                snapshot.appendItems(products, toSection: section)
                dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
            }
        }
    }
    
    func createMaterialSection(sectionIndex: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(305)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(305)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
      let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
        return self?.createMaterialSection(sectionIndex: section)
      }
      return layout
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.openProductDetails(at: indexPath.row)
    }
}

extension ProductListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if position > contentHeight - frameHeight * 1.5 {
            presenter.loadNextPageIfNeeded()
        }
    }
}
