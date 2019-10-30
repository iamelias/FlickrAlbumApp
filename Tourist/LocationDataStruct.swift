//
//  LocationDataStruct.swift
//  Tourist
//
//  Created by Elias Hall on 10/27/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import UIKit

struct LocationDataStruct {
    
    var LocationData: [UIImage] //holding the saved PicArray
    
    init(_ data: [UIImage]) {
        self.LocationData = data
    }
}
