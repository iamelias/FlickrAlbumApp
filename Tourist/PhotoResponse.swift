//
//  PhotoResponse.swift
//  Tourist
//
//  Created by Elias Hall on 10/27/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation

struct PhotoResponse: Codable {
    
    let id: String? = ""
    let owner: String? = ""
    let secret: String? = ""
    let server: String? = ""
    let farm: Int? = 0
    let title: String? = ""
    let ispublic: Int? = 0
    let isfriend: Int? = 0
    let isfamily: Int? = 0
}
