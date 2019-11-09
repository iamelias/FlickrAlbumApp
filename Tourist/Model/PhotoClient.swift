//
//  PhotoClient.swift
//  Tourist
//
//  Created by Elias Hall on 10/27/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import UIKit

class PhotoClient {
    
    class func getPhotos(_ selectedPin: Pin, completion: @escaping (Bool, Error?) -> Void) {
        
        let randomPage = Int.random(in: 1..<6) // random page to call for empty photo album
        
        let photoEndpointRequest = URLRequest(url: URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=9c023ba4945ad4e3608893500bd25d42&lat=\(selectedPin.latitude)&lon=\(selectedPin.longitude)&per_page=20&page=\(randomPage)&format=json&nojsoncallback=1")!)
        
        let task = URLSession.shared.dataTask(with: photoEndpointRequest) { data, response, error in
            guard data != nil else {
                DispatchQueue.main.async {
                    completion(false,error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let myResponseObjects = try decoder.decode(PhotoJSON1.self, from: data!) //parsing
                
                PhotoDataStruct.savedPhotoData = myResponseObjects.self.photos.photo
                
                DispatchQueue.main.async {
                    completion(true,nil)
                }
            }
                
            catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func requestImageFile (sUrl: URL, passingPin: Pin!, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        
        let task2 =
            URLSession.shared.dataTask(with: sUrl) { dataURL, response, error in
                if let dataURL = dataURL {
                    let downloadedImage = UIImage(data: dataURL)
                    completionHandler(downloadedImage, nil)
                }
        }
        task2.resume()
    }
}

