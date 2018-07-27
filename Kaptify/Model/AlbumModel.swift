//
//  AlbumModel.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-07-18.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import Foundation

struct Album: Decodable {
    let artistName: String?
    let id: String?
    let releaseDate: String?
    let name: String?
    let artworkUrl100: String?
//    let kind: String?
//    let copyright: String?
//    let artistId: String?
//    let artistUrl: String?
//    struct Genre: Decodable {
//        let genreId: String?
//        let name: String?
//        let url: String?
//    }
//    let genres: [Genre]?
    let url: String?
    
    init(artist: String, name: String, artUrl: String, releaseDate: String, url: String, id: String) {
        self.artistName = artist
        self.name = name
        self.artworkUrl100 = artUrl
        self.releaseDate = releaseDate
        self.url = url
        self.id = id
    }
    
    func stringToUrl(url: String) -> URL {
        return URL(string: url)!
    }
}
