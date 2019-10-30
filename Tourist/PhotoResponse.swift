//
//  PhotoResponse.swift
//  Tourist
//
//  Created by Elias Hall on 10/27/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

struct PhotoResponse: Codable {
    
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}
