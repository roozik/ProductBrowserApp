//
//  DomainConvertable.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import Foundation

public protocol DomainConvertible {
  associatedtype DomainModel
  func toDomain() -> DomainModel
}

public extension Array where Element: DomainConvertible {
  func toDomain() -> [Element.DomainModel] {
    map { $0.toDomain() }
  }
}
