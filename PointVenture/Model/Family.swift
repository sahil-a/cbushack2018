//
//  Family.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/21/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import Foundation

struct Family: Serializable {
    var name: String
    var imageURL: String = "None"
    var points: Int = 1000
    var hashedCode: String
    var individuals: [Individual] = []
    var manualOverrideEnabled: Bool = false
    var primaryKey: String?
    var individualKeys: [String] = []
    
    init(name: String, hashedCode: String, individuals: [Individual]) {
        self.name = name
        self.hashedCode = hashedCode
        self.individuals = individuals
    }
}

struct Individual: Serializable {
    var isParent: Bool
    var points: Int
    var displayName: String
    var name: String
    var imageURL: String = "None"
    var primaryKey: String?
    
    init(isParent: Bool, name: String, displayName: String) {
        self.isParent = isParent
        points = isParent ? 750 : 500
        self.name = name
        self.displayName = displayName
    }
}

protocol Serializable: Codable {
    func serialize() -> String?
    static func deserialize(json: String) -> Serializable?
}

extension Serializable {
    func serialize() -> String? {
        let encoder = JSONEncoder()
        let data = (try? encoder.encode(self)) ?? Data()
        return String(data: data, encoding: .utf8)
    }
    static func deserialize(json: String) -> Serializable? {
        let data = json.data(using: .utf8) ?? Data()
        return try? JSONDecoder().decode(self.self, from: data)
    }
}
