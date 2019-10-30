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
    
    class func getPhotos(completion: @escaping (Bool, Error?) -> Void) {
        //print("REACHED get Photos")
        
        //        let photoEndpointRequest = URLRequest(url: URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=9c023ba4945ad4e3608893500bd25d42&lat=34.0522&lon=118.2437&format=json&nojsoncallback=1")!)
        
        //        let photoEndpointRequest = URLRequest(url: URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=9c023ba4945ad4e3608893500bd25d42&lat=\(CoordinateStruct.latitude)&lon=\(CoordinateStruct.longitude)&format=json&nojsoncallback=1")!)
        
        //        let photoEndpointRequest = URLRequest(url: URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=9c023ba4945ad4e3608893500bd25d42&lat=\(CoordinateStruct.latitude)&lon=\(CoordinateStruct.longitude)&format=json&nojsoncallback=1")!)
        
        let photoEndpointRequest2 = URLRequest(url: URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=9c023ba4945ad4e3608893500bd25d42&lat=\(CoordinateStruct.latitude)&lon=\(CoordinateStruct.longitude)&per_page=5&page=1&format=json&nojsoncallback=1")!)
        //     //   print(photoEndpointRequest)
        
        let task = URLSession.shared.dataTask(with: photoEndpointRequest2) { data, response, error in
            guard data != nil else {
                DispatchQueue.main.async {
                    // print("parsing failed 1")
                    completion(false,nil)
                }
                return
            }
            //
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, nil)
                    return
                }
            }
            
            let decoder = JSONDecoder()
            
            do {
                //  print("Before Parsing")
                let myResponseObjects = try decoder.decode(PhotoJSON1.self, from: data!) //parsing
                //   print("After Parsing")
                // print(myResponseObjects)
                
                
                LocationsSave.savedLocations = myResponseObjects.self.photos.photo
                guard LocationsSave.savedLocations.count != 0 else {
                    //
                    //                        let alert = UIAlertController(title: "No Photos", message: "There where no photos at your coordinates", preferredStyle: .alert)
                    //                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction) in
                    //                                   return //Don't add pin
                    //                               })
                    //
                    //                        alert.addAction(okAction)
                    //
                    //                        present(alert, animated: true, completion: nil) //Display Alert
                    return
                }
                
                //  print("Test making url index 0")
                //                    let url: String = "https://farm\(LocationsSave.savedLocations[0].farm).staticflickr.com/\(LocationsSave.savedLocations[0].server)/\(LocationsSave.savedLocations[0].id)_\(LocationsSave.savedLocations[0].secret)_m.jpg"
                //          //  print("******************************************************************")
                //
                //                   // PhotoClient.photoUrl = url
                //                     let updatedURL = URL(string: url)
                //                    URLInfo.convertedURL = updatedURL
                
                DispatchQueue.main.async {
                    completion(true,nil)
                }
            }
                
            catch {
                DispatchQueue.main.async {
                    //  print("parsing failed 2")
                    completion(false, nil)
                }
            }
        }
        task.resume()
    }
    
    class func requestImageFile (url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        //  print("^^^^^^^^^^^ \(URLInfo.convertedURL!)")
        let task2 =
            URLSession.shared.dataTask(with: url) { InfoURL, response, error in
                if let InfoURL = InfoURL {
                    let downloadedImage = UIImage(data: InfoURL)
                    URLInfo.downloadImage = downloadedImage
                    if URLInfo.downloadImage == nil {
                        //   print("In PhotoClient nil")
                    }
                    else {
                        //   print("URLInfo has value")
                        DispatchQueue.global().sync{
                            completionHandler(downloadedImage, nil)
                        }
                        
                    }
                    
                }
                //else { print("failure")}
        }
        task2.resume()
    }
    
}

