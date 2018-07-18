//
//  MetadataModel.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-07-18.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import Foundation

struct object: Decodable {
    let feed: Feed?
}

struct Feed: Decodable {
    let title: String?
    let id: String?
    
    
    struct Author: Decodable {
        let name: String?
        let uri: String?
    }
    
    let author: Author?
    struct Link: Decodable {
        let url: String?
        private enum CodingKeys: String, CodingKey {
            case url = "self"
        }
    }
    let links: [Link]?
    let copyright: String?
    let country: String?
    let icon: String?
    let updated: String?
    
    let results: [Album]?
}
