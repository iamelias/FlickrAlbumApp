//
//  AdditionalDataStruct.swift
//  Tourist
//
//  Created by Elias Hall on 10/27/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

struct AdditionalDataStruct { //Going to be initialized when pin is created
    static var annotationPinKey: String? //storing Pin for Key for Dictionary
    static var LocationArrayData: [UIImage] = [] //Storing Location Images for Dictionary
    // static var isInitialRun: Bool = false
    //  static var PinOnlyDict: Bool = false
}

var AnnoArrayDict: [String : [UIImage]] = [:]

