//
//  ViewModelStreams.swift
//  ITBookShelf
//
//  Created by JunKyung.Park on 2021/01/20.
//

import Foundation

protocol ViewModelStream {
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

protocol ViewModelStreamInternals {
    associatedtype Base
    init(base: Base)
}

class ViewModelType<Base: ViewModelStream>: ViewModelStream {
    private(set) lazy var inputs: Base.Input = { base.inputs }()
    private(set) lazy var outputs: Base.Output = { base.outputs }()
    private var base: Base
    init(_ base: Base) {
        self.base = base
    }
    deinit { print("ViewModelType Deinit Base == \(Base.self)") }
}
