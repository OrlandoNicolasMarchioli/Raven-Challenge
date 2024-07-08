//
//  Media.swift
//  RavenChallenge
//
//  Created by Nico on 08/07/2024.
//

import Foundation

struct Media: Codable {
    let type: String
    let subtype: String?
    let caption: String?
    let copyright: String
    let approvedForSyndication: Int
    let mediaMetadata: [MediaMetadata]

    enum CodingKeys: String, CodingKey {
        case type
        case subtype
        case caption
        case copyright
        case approvedForSyndication = "approved_for_syndication"
        case mediaMetadata = "media-metadata"
    }
}
