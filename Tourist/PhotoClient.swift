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
        //print("REACHED get Photos")
//
//        let photoEndpointRequest = URLRequest(url: URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=9c023ba4945ad4e3608893500bd25d42&lat=\(selectedPin.latitude)&lon=\(selectedPin.longitude)&per_page=5&page=1&format=json&nojsoncallback=1")!)
        //     //   print(photoEndpointRequest)
        
        //For random page
        
        let randomPage = Int.random(in: 1..<6)
        
        let photoEndpointRequest = URLRequest(url: URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=9c023ba4945ad4e3608893500bd25d42&lat=\(selectedPin.latitude)&lon=\(selectedPin.longitude)&per_page=3&page=\(randomPage)&format=json&nojsoncallback=1")!)
        
        
//        https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=9c023ba4945ad4e3608893500bd25d42&lat=34.0522&lon=118.2437&per_page=10&page=\(randomPage)&format=json&nojsoncallback=1
        
        let task = URLSession.shared.dataTask(with: photoEndpointRequest) { data, response, error in
            guard data != nil else {
                DispatchQueue.main.async {
                    // print("parsing failed 1")
                    completion(false,error)
                }
                return
            }
            //
//            if error != nil {
//                DispatchQueue.main.async {
//                    completion(false, nil)
//                    return
//                }
//            }
            
            let decoder = JSONDecoder()
            
            do {
                let myResponseObjects = try decoder.decode(PhotoJSON1.self, from: data!) //parsing
 
                PhotoDataStruct.savedPhotoData = myResponseObjects.self.photos.photo
                PhotoPageStruct.savedPageInfo = [myResponseObjects]
                //let num = Int.random(in 1..<PhotoPageStruct.savedPageInfo[0].photos.pages)
                
//                guard PhotoDataStruct.savedPhotoData.count != 0 else {
//                    completion(false, nil) //there are no photos at location
//                    return
//                }
                DispatchQueue.main.async {
                    completion(true,nil)
                }
            }
                
            catch {
                DispatchQueue.main.async {
                    //  print("parsing failed 2")
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func requestImageFile (sUrl: URL, passingPin: Pin!, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        
        //getting data/image from url
        let task2 =
            URLSession.shared.dataTask(with: sUrl) { dataURL, response, error in
                if let dataURL = dataURL {
                    let downloadedImage = UIImage(data: dataURL) //saving as UIImage in download image
                    URLInfo.downloadImage = downloadedImage //saving copy to static array
                    if downloadedImage == nil { //respond by making image placeholder image
                        print("In PhotoClient nil")
                        completionHandler(nil, error)
                    }
                    else {
                        //   print("URLInfo has value")
                      //  DispatchQueue.global().async{
                            completionHandler(downloadedImage, nil) //sending downloadedImage
                     //   }
                        
                    }
                    
                }
                //else { print("failure")}
        }
        task2.resume()
    }
    
}

