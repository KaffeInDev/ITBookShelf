//
//  DependancyInjectable.swift
//  
//
//  Created by JunKyung.Park on 2021/06/09.
//

import Foundation

public protocol DepandancyAssociatable {
    associatedtype Dependancy
}

public protocol DependancyInstantiable: DepandancyAssociatable {
    static func instantiate(_ dependancy: Dependancy) -> Self
}

public protocol DependancyConfigurable: DepandancyAssociatable {
    func configure(_ dependancy: Dependancy)
}
