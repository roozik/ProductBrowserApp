//
//  ProductsListPresenterTests.swift
//  ProductBrowserAppTests
//
//  Created by Ruzanna on 19.05.25.
//

import Foundation
import XCTest
import Combine
@testable import ProductBrowserApp

final class ProductsListPresenterTests: XCTestCase {
       
    private var sut: ProductListPresenter!
    private var repositoryMock: DataRepositoryProtocolMock!
    private var productListViewMock: ProductListViewMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        repositoryMock = DataRepositoryProtocolMock()
        productListViewMock = ProductListViewMock()
        sut = ProductListPresenter(
            repository: repositoryMock,
            productListView: productListViewMock,
            coordinator: nil)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        repositoryMock = nil
        productListViewMock = nil
    }
    
    func testLoadData_shouldCallViewUpdate_withSuccess() {
        // given
        repositoryMock.products = [
            ProductItem(product: .init(id: 1, title: "Test", price: 1.0, description: "desc1", images: [])),
            ProductItem(product: .init(id: 2, title: "Test2", price: 12.0, description: "desc2", images: []))
        ]

        // when
        sut.loadData()
        
        // then
        XCTAssertNotNil(productListViewMock.lastUpdate)
        if case .success(let items) = productListViewMock.lastUpdate {
            XCTAssertEqual(items.count, 2)
            XCTAssertEqual(items[0].title, "Test")
        } else {
            XCTFail("Expected success")
        }
    }
    
    func testLoadData_shouldCallViewUpdate_withErrorAlert() {
        // given
        repositoryMock.shouldReturnError = true

        // when
        sut.loadData()
        
        // then
        XCTAssertNotNil(productListViewMock.lastUpdate)
        if case .error(let error) = productListViewMock.lastUpdate {
            XCTAssertTrue(error == NetworkError.invalidResponse)
        } else {
            XCTFail("Expected success")
        }
    }
    
    func testLoadNextPageIfNeeded_shouldIncrementPageAndCallLoadData() {
     
        // given
        repositoryMock.products = [
            ProductItem(product: .init(id: 1, title: "Test", price: 1.0, description: "desc1", images: [])),
            ProductItem(product: .init(id: 2, title: "Test2", price: 12.0, description: "desc2", images: []))
        ]
        sut.loadData()
            
        // when
        repositoryMock.products = [
            ProductItem(product: .init(id: 3, title: "Test3", price: 1.0, description: "desc3", images: [])),
            ProductItem(product: .init(id: 2, title: "Test2", price: 12.0, description: "desc2", images: []))
        ]
        sut.loadNextPageIfNeeded()

        // then
        XCTAssertEqual(sut.currentPage, 1)
        if case .success(let items) = productListViewMock.lastUpdate {
            XCTAssertEqual(items.count, 1)
            XCTAssertEqual(items[0].title, "Test3")
        } else {
            XCTFail("Expected success")
        }
    }
    
    func testRefreshData_shouldResetPageAndLoadData() {
        // given
        repositoryMock.products = [
            ProductItem(product: .init(id: 1, title: "Test", price: 1.0, description: "desc1", images: [])),
            ProductItem(product: .init(id: 2, title: "Test2", price: 12.0, description: "desc2", images: []))
        ]
        sut.loadData()
        
        //when
        repositoryMock.products = []
        sut.refreshData()

        // then
        XCTAssertEqual(sut.currentPage, 0)
        if case .success(let items) = productListViewMock.lastUpdate {
            XCTAssertEqual(items.count, 0)
        } else {
            XCTFail("Expected success")
        }
    }
}


final class DataRepositoryProtocolMock: DataRepositoryProtocol {
    var shouldReturnError = false
    var products: [ProductItem] = []
    var favoritedIDs: Set<Int> = []

    func fetchProducts(page: Int) -> AnyPublisher<[ProductItem], NetworkError> {
        if shouldReturnError {
            return Fail(error: NetworkError.invalidResponse)
                .eraseToAnyPublisher()
        } else {
            return Just(products)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func toggleFavorite(id: Int) {
        if favoritedIDs.contains(id) {
            favoritedIDs.remove(id)
        } else {
            favoritedIDs.insert(id)
        }
    }
    
    func isFavorite(id: Int) -> Bool {
        return favoritedIDs.contains(id)
    }
}


final class ProductListViewMock: ProductListView {
    var lastUpdate: DataResult<ProductItem>?

    func updateData(_ data: DataResult<ProductItem>) {
        lastUpdate = data
    }
    
    func updateSingleItem(_ item: ProductBrowserApp.ProductItem) {}
}
