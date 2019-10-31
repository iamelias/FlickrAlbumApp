//
//  PhotoAlbumController.swift
//  Tourist
//
//  Created by Elias Hall on 10/27/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PhotoAlbumController: UIViewController, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    static var PicArray: [UIImage] = []
    static var convertURLs: [URL] = []
    static var saveCheck: Bool = false
    static var secondGo: Bool = false
   
    var keyExists: Bool? = false //retrieved from TravelLocationController using segue
    var dataController: DataController!
    
    @IBOutlet weak var collecImage: UIImageView!
    @IBOutlet weak var collecView: UICollectionView!
    @IBOutlet weak var Image: UIImageView!
    
    var pin: Pin!
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        self.collecView.delegate = self
        self.collecView.dataSource = self
        
        print(keyExists!)
        PhotoAlbumController.PicArray.removeAll()
        
        //        guard keyExists == false else {
        //            PhotoAlbumController.PicArray = AnnoArrayDict[AditionalDataStruct.annotationPinKey!]!
        //            return
        //        }
        //
        //        DispatchQueue.global().async {
        //            PhotoClient.getPhotos(completion: self.handlePhotoResponse(success: error:))
        //        }
        if keyExists == true {
            
            PhotoAlbumController.PicArray = AnnoArrayDict[AdditionalDataStruct.annotationPinKey!]!
        }
            
        else {
            DispatchQueue.global().async {
                PhotoClient.getPhotos(completion: self.handlePhotoResponse(success: error:))
            }
        }
        
    }
    
    func viewWillAppear() {
    }
    
    func viewDidAppear() {
        
        
        //        if PhotoAlbumController.saveCheck == false {
        //        PhotoClient.getPhotos(completion: self.handlePhotoResponse(success: error:))
        //
        //        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //@@@@
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) //3 cells
    }
    
    //@@@@
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //print(PhotoAlbumController.convertURLs.count)
        
        if PhotoAlbumController.PicArray.count != 0 {
            //  PhotoAlbumController.saveCheck = true
            
        }
        return PhotoAlbumController.PicArray.count
        
    }
    
    //@@@@
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photocell", for: indexPath) as! photoCollectionCell
        
        // if PhotoAlbumController.secondGo {
        cell.cellView.image = UIImage(named: "VirtualTourist_120") // default image
        
        //  if PhotoAlbumController.secondGo == true {
        // AditionalDataStruct.LocationArrayData = PhotoAlbumController.PicArray
        // createDictionaryElement() //creating dictionary element with saved data
        
        if keyExists == false {
            AdditionalDataStruct.LocationArrayData = PhotoAlbumController.PicArray
            AnnoArrayDict[AdditionalDataStruct.annotationPinKey!] = AdditionalDataStruct.LocationArrayData
        }
        
        cell.cellView?.image = PhotoAlbumController.PicArray[(indexPath.row)] //adding
        // }
        // }
        return cell
        
    }
    
    //    func createDictionaryElement() { // storing value location for dictionary
    //
    //        if AditionalDataStruct.PinOnlyDict == true { //If pin only dictionary exists
    //        AnnoArrayDict[AditionalDataStruct.annotationPinKey!] =  AditionalDataStruct.LocationArrayData //adding pin's value to create full dictionary element
    //            AditionalDataStruct.PinOnlyDict = false //turning off
    //        }
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
    }
    
    @IBAction func CancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func NewCollectionButton(_ sender: Any) {
        PhotoAlbumController.PicArray.removeAll()
        PhotoClient.getPhotos(completion: self.handlePhotoResponse(success: error:))
        collecView.reloadData()
    }
    
    func createURLs() {
        
        var urlArray: [URL] = []
        
        for i in 0..<LocationsSave.savedLocations.count {
            
            let LocationsUrl = "https://farm\(LocationsSave.savedLocations[i].farm).staticflickr.com/\(LocationsSave.savedLocations[i].server)/\(LocationsSave.savedLocations[i].id)_\(LocationsSave.savedLocations[i].secret)_m.jpg"
            
            let convertUrl = URL(string: LocationsUrl)!
            
            urlArray.append(convertUrl)
        }
        
        URLInfo.convertedArrayUrls = urlArray //saving converted urls to global array
    }
    
    func handlePhotoResponse(success: Bool, error: Error?) {
        
        if success {
            //   print("HandlePhotoResponse was reached")
            createURLs()
            //PhotoAlbumController.secondGo = true
            // print(URLInfo.convertedArrayUrls.count)
            DispatchQueue.global().sync {
                for i in 0..<URLInfo.convertedArrayUrls.count {
                    PhotoClient.requestImageFile(url: URLInfo.convertedArrayUrls[i], completionHandler: self.handleURLImageResponse(image:error:))
                }
            }
        }
        collecView.reloadData()
        
        return
        
    }
    
    func handleURLImageResponse(image: UIImage?, error: Error?) {
        //  print("URLImageHandle before dispatch")
        //DispatchQueue.global().sync {
        // print("HandleURLImageResponse was reached")
        //            if URLInfo.downloadImage == nil {
        //            }
        
        DispatchQueue.main.async {
            PhotoAlbumController.PicArray.append(URLInfo.downloadImage!)
            //LocationDataStruct.LocationData.append(URLInfo.downloadImage!)
        }
        // }
        // print(PhotoAlbumController.PicArray.count)
        
        DispatchQueue.main.async {
            self.collecView.reloadData()
            
        }
        return
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        print("*****************")
        print(AnnoArrayDict)
        print("*****************")
        
        
    }
}
