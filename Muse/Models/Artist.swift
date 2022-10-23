//
//  Artist.swift
//  Muse
//
//  Created by Michel Maalouli on 8/13/22.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
