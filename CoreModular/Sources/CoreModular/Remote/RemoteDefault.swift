//
//  RemoteDefault.swift
//  
//
//  Created by JunKyung.Park on 2021/05/12.
//

import UIKit

open class RemoteDefault {
    public static var policy: RemotePolicy?
}
public struct RemotePolicy {
    public enum Timeout: TimeInterval {
        case `default` = 10
        case polling = 180
    }
    let host: String
    let timeout: Timeout
    
    public init(host: String, timeout: Timeout = .default) {
        self.host = host
        self.timeout = timeout
    }
}
