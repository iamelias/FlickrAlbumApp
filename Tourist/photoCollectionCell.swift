//
//  photoCollectionCell.swift
//  Tourist
//
//  Created by Elias Hall on 10/27/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import UIKit

final class photoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIImageView!
    
    var placeHolderImage: UIImage! {
        didSet {
            cellView.image = UIImage(named: "VirtualTourist_120" )
        }
    }
}
