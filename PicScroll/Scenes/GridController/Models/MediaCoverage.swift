//
//  MediaCoverage.swift
//  PicScroll
//
//  Created by Dhruv Govani on 16/04/24.
//

import Foundation

struct MediaCoverageElement: Codable {
    let id: String?
    let thumbnail: Thumbnail?
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let id: String?
    let version: Int?
    let domain: String?
    let basePath: String?
    let key: String?
    let qualities: [Int]?
    let aspectRatio: Int?
    
    var downloadURL: URL?{
        return URL(string: (domain ?? "") + "/" + (basePath ?? "") + ("/\(qualities?.first ?? 10)/") + (key ?? "") ) ?? nil
    }
    
}
