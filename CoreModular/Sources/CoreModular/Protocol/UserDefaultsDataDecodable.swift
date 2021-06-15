//
//  UserDefaultsDataDecodable.swift
//  
//
//  Created by JunKyung.Park on 2021/06/15.
//

import Foundation

public protocol UserDefaultsCodable {
}

public extension UserDefaultsCodable {
    func userDefaultsEncode(key: String) throws {
        try UserDefaults.standard.set(
            JSONEncoder().encode(text),
            forKey: key
        )
    }
    
    func userDefaultsDecode<T: Codable>(key: String) throws -> T {
        guard let data = UserDefaults.standard.object(
                forKey: key
        ) as? Data else {
            throw ResultError.dataIsNil
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func userDefaultsDecode<T: Codable, Case: RawRepresentable>(key: Case)
    throws -> T where Case.RawValue == String {
        try userDefaultsDecode(key: String(key.rawValue))
    }
}
