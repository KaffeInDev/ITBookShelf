//
//  ViewModelStreams.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/20.
//

import Foundation

public protocol ViewModelStream {
    associatedtype Input
    associatedtype Output
    
    var inputs: Input { get }
    var outputs: Output { get }
}

extension ViewModelStream {
    @discardableResult
    func transform(inputs closure: ((Input) -> Void)?) -> Output {
        closure?(inputs)
        return outputs
    }
}

public protocol ViewModelStreamInternals {
    associatedtype Base
    init(base: Base)
}

open class ViewModelType<Base: ViewModelStream>: ViewModelStream {
    private(set) lazy public var inputs: Base.Input = { base.inputs }()
    private(set) lazy public var outputs: Base.Output = { base.outputs }()
    private var base: Base
    public init(_ base: Base) {
        self.base = base
    }
    deinit { print("ViewModelType Deinit Base == \(Base.self)") }
}
