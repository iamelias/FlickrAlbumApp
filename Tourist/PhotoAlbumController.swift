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
import CoreGraphics

class PhotoAlbumController: UIViewController, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    static var convertUrl: URL = URL(string: "Init")!
   
    var dataController: DataController!
    
    @IBOutlet weak var collecView: UICollectionView!
    
    var selectedPin: Pin! //pin from TouristLocationsViewController
    var photos: [Photo] = [] //local array that stores photos associated with selected Pin
    
    override func viewDidLoad() {//****************
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        self.collecView.delegate = self
        self.collecView.dataSource = self
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", selectedPin) //%@ will get replaced by selectedPin at runtime. Purpose is to get photos filtered for selected pin
        fetchRequest.predicate = predicate //using setup predicate
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false ) //top is newest photos
        fetchRequest.sortDescriptors = [sortDescriptor]
        var result:[Photo] = [] //array holds fetched photos
        photos = result
        do {
        let inResult = try self.dataController.viewContext.fetch(fetchRequest) //fetching photos
            result = inResult
        }
        catch let error {
            print("There is error: \(error)")
        }
        
        collecView.reloadData()
        if result.isEmpty { //If no photos are persisted for pin call client
            DispatchQueue.global(qos: .background).async {
                PhotoClient.getPhotos(self.selectedPin, completion: self.handlePhotoResponse(success: error:))
            }
        }
            
        else {
        photos = result.reversed() //Use results if not empty
        DispatchQueue.main.async {
        self.collecView.reloadData()
        }
        return
        }
    }
    
    func handlePhotoResponse(success: Bool, error: Error?) {//***************
        if success == true { // if success is returned
                if PhotoDataStruct.savedPhotoData.count == 0 { //present alert if call is made but no response objects are returned
                
                let alert = UIAlertController(title: "No Photos", message: "There are no photos at this location", preferredStyle: .alert
                )
                
                let okAlert = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alert.addAction(okAlert)
                
                present(alert,animated: true,completion: nil)
                return
            }
                else { //if 1 or more response objects are returned
                    
           // collecView.reloadData()
            
            DispatchQueue.global(qos: .background).async {
            for i in 0..<PhotoDataStruct.savedPhotoData.count {
            self.createUrl(i) //i is counter starting at 0 in loop. creating url for each response object
                        }
                    }
            }
        }
        
        else if success == false { //if false is returned // Display a localized error alert
            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert
            )
            
            let okAlert = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(okAlert)
            
            present(alert,animated: true,completion: nil)
            return
        }
        self.collecView.reloadData()
        return
    }
    
    func createUrl(_ i: Int) { //***************
        //Full method is completed for each iteration
        let LocationsUrl = "https://farm\(PhotoDataStruct.savedPhotoData[i].farm).staticflickr.com/\(PhotoDataStruct.savedPhotoData[i].server)/\(PhotoDataStruct.savedPhotoData[i].id)_\(PhotoDataStruct.savedPhotoData[i].secret)_m.jpg"
        
        let convertedPhotoUrl = URL(string: LocationsUrl)! //converting LocationsURL string to url
        PhotoAlbumController.convertUrl = convertedPhotoUrl //storing copy converted Url in static variable
        PhotoClient.requestImageFile(sUrl: convertedPhotoUrl, passingPin: selectedPin!, completionHandler: self.handleURLImageResponse(downloadedImage:error:)) //calling for url's data
    }

    func handleURLImageResponse(downloadedImage: UIImage?, error: Error?) { //*****************
        var imageData = UIImage(named: "VirtualTourist_120")?.jpegData(compressionQuality: 0.1) //init image data to placeholder image
        
        if downloadedImage != nil {
            
            imageData = downloadedImage!.jpegData(compressionQuality: 0.5) //if image exists replace placeholder
        }

        let persistPhoto = Photo(context: dataController.viewContext) //defining persisted data attributes
        persistPhoto.url = PhotoAlbumController.convertUrl.description
        persistPhoto.image = imageData
        persistPhoto.creationDate = Date()
        persistPhoto.latitude = selectedPin.latitude
        persistPhoto.longitude = selectedPin.longitude
        persistPhoto.pin = selectedPin
        photos.append(persistPhoto) //adding photo to local array

        do {
            try self.dataController.viewContext.save()
        }

        catch let error {
            print("Failed to save photo in addPhoto() because of \(error)")
        }
        
        DispatchQueue.main.async {
            self.collecView.reloadData()
        }
        return
    }
    
    @IBAction func cancelButton(_ sender: Any) { //*****************
        dismiss(animated: true) //return to TouristLocationsController
    }
    
    @IBAction func NewCollectionButton(_ sender: Any) { //***************
        for i in 0..<photos.count {
            self.dataController.viewContext.delete(photos[i]) //deleting persisted photos
            
            do {
                try self.dataController.viewContext.save()
            }
            catch {
                print("There was error deleting")
                return
            }
        }
        
        photos.removeAll() //removing photos from the in-class photo array
        
        collecView.reloadData()
        PhotoClient.getPhotos(selectedPin, completion: self.handlePhotoResponse(success: error:)) //calling new photos
        
        self.collecView.reloadData() //updating view after adding new photos
        return
    }
    
    //*************** CollecView *******************
    func numberOfSections(in collectionView: UICollectionView) -> Int { //**********
        return 1 //1 section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { //************
        let width = (view.frame.width - 20)/3
        return CGSize(width: width, height: 100) //3 cells per width on iphone xs
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {//*****
        return photos.count //uses photos entity photos array
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //************
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photocell", for: indexPath) as! photoCollectionCell
        
        cell.cellView.image = UIImage(named: "VirtualTourist_120") // default image first load

        
        guard photos[indexPath.row].image != nil else {//***********
            
            cell.cellView.image = nil
            return cell
        }
                cell.cellView.image = UIImage(data: (self.photos[indexPath.row].image!)) //assinging image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {//********
        self.dataController.viewContext.delete(photos[indexPath.row])
        do {
            try self.dataController.viewContext.save()
            collecView.reloadData()
        }
        catch {
            print("error removing from collecView")
        }
    }
}
