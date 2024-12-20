//
//  ItemsResponse.swift
//  MarketplaceListing
//
//  Created by Hamza on 18/12/2024.
//

import Foundation

// MARK: - RootResponse

struct ItemsResponse: Codable {
    let paging: Paging
    let data: [Item]
}

extension ItemsResponse: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.paging == rhs.paging
    }
}

// MARK: - Paging

struct Paging: Codable {
    let after: String
    let before: String?
    let pageLength: Int
}

extension Paging: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.before == rhs.before &&
            lhs.after == rhs.after &&
            lhs.pageLength == rhs.pageLength
    }
}

// MARK: - Item

struct Item: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let location: Location
    let pictures: [Picture]

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, description, location, pictures
    }
}

extension Item: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Item: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(description)
    }
}

// MARK: - Location

struct Location: Codable {
    let city: String
    let country: String
    let department: String
    let latitude: Double
    let longitude: Double
    let obfuscated: Bool
}

// MARK: - Picture

struct Picture: Codable {
    let squares32: String
    let squares64: String
    let squares128: String
    let squares300: String
    let squares600: String
    let resizes1000: String
}
