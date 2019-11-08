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
    
    @IBOutlet weak var collecImage: UIImageView!
    @IBOutlet weak var collecView: UICollectionView!
    @IBOutlet weak var Image: UIImageView!
    
    var selectedPin: Pin! //from TouristLocationsViewController
    var photos: [Photo] = [] //stores photos associated with selected Pin
    var addedImages: [UIImage] = []
    
    override func viewDidLoad() { //****************
        print("Made it to viewDidLoad in PhotoAlbumController")
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        self.collecView.delegate = self
        self.collecView.dataSource = self
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest() //fetching from Photo Entity
        let predicate = NSPredicate(format: "pin == %@", selectedPin) //%@ will get replaced by pin at runtime. Purpose is to get photos filtered for selected pin
        fetchRequest.predicate = predicate //fetchRequest is set to use predicate
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false ) //top is newest photos
        fetchRequest.sortDescriptors = [sortDescriptor] //fetch will be sorted by creationDate ascending
        var result:[Photo] = [] //to hold fetched core data
        
//        if let inResult = try? dataController?.viewContext.fetch(fetchRequest) {
//            result = inResult
//            print("%%%%%%%%%%%%%%%%%%%%%")
//            print(inResult.count)
//            print(inResult)
//            print("@@@@")
//            print(result.isEmpty)
//            print("%%%%%%%%%%%%%%%%%%%%%")
//        }
//        else {
//            print("unable to fetch")
//        }
        
        do {
        let inResult = try self.dataController.viewContext.fetch(fetchRequest)
            print("%%%%%%%%%%%%%%%%%%%%%")
            print(inResult.count)
            print(inResult)
            print("%%%%%%%%%%%%%%%%%%%%%")
            result = inResult

        }
        catch let error {
            print("There is error: \(error)")
        }
        
        print(result.isEmpty)
        if result.isEmpty {
            print("^^^^^^^^^^^")
            print(result.count)
            print(result)
            print("^^^^^^^^^^^")

        print("about to call PhotoClient in viewDidLoad")
        //call PhotoClient if results is empty
           // let randomPageNum = Int.random(in: 1..<10)
        PhotoClient.getPhotos(selectedPin, completion: self.handlePhotoResponse(success: error:))
        self.collecView.reloadData()
        print("End ViewDidLoad")
            
            
        }
        
        else {
            
        photos = result //Use results if not empty
        print("This is the viewDidLoad photos count: \(photos.count)")
        DispatchQueue.main.async {
        self.collecView.reloadData()
        }
        return
            
        }

//        if let result = try? dataController.viewContext.fetch(fetchRequest) {//making fetchRequest
//            print("%%%%%%%%%%%%%%%%%%%%")
//            print(result.count)
//            print(result)
//            print("%%%%%%%%%%%%%%%%%%%")
////            guard result.isEmpty else {
//            if result.isEmpty {
//
//                print("about to call PhotoClient in viewDidLoad")
//                //call PhotoClient if results is empty
//                PhotoClient.getPhotos(completion: self.handlePhotoResponse(success: error:))
//                self.collecView.reloadData()
//                print("End ViewDidLoad")
//
//            }
//
//        else {
//                photos = result //Use results if not empty
//                print("This is the viewDidLoad photos count: \(photos.count)")
//                DispatchQueue.main.async {
//                     self.collecView.reloadData()
//                }
//                return
//        }
//        }
        
    }
    
    func viewDidAppear() {
        DispatchQueue.main.async {
        self.collecView.reloadData()
        }
    }
    
    func handlePhotoResponse(success: Bool, error: Error?) {//**************** unecessary ***
        print("made it to handlePhotoResponse")
        
        if success == true { // if success is returned
                if PhotoDataStruct.savedPhotoData.count == 0 {
                
                let alert = UIAlertController(title: "No Photos", message: "There are no photos at this location", preferredStyle: .alert
                )
                
                let okAlert = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alert.addAction(okAlert)
                
                present(alert,animated: true,completion: nil)
                return
            }
            
            
                else {
            
            for i in 0..<PhotoDataStruct.savedPhotoData.count {//LocationsSave is a static copy of network data
            createUrl(i) //i is counter starting at 0 in loop
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
        
        print("calling collecViewreload in handlePhotoResponse")
        self.collecView.reloadData()
        print("reached end of handlePhotoResponse")
        return
    }
    
//    func formthrowableURL(_ i: Int) throws -> String {
//
//    let LocationsUrl = "https://farm\(PhotoDataStruct.savedPhotoData[i].farm).staticflickr.com/\(PhotoDataStruct.savedPhotoData[i].server)/\(PhotoDataStruct.savedPhotoData[i].id)_\(PhotoDataStruct.savedPhotoData[i].secret)_m.jpg"
//
//        return LocationsUrl
//    }
    
    func createUrl(_ i: Int) { //*************** passing counter
        print("made it to createUrl method")
        print("createURL call: \(i + 1)") //how many calls to createURL function?
        //Full method is completed for each iteration
        //setting up url using i for element for each photo call using
        
        let LocationsUrl = "https://farm\(PhotoDataStruct.savedPhotoData[i].farm).staticflickr.com/\(PhotoDataStruct.savedPhotoData[i].server)/\(PhotoDataStruct.savedPhotoData[i].id)_\(PhotoDataStruct.savedPhotoData[i].secret)_m.jpg"
        
        let convertedPhotoUrl = URL(string: LocationsUrl)! //converting string to url
        PhotoAlbumController.convertUrl = convertedPhotoUrl //storing copy converted Url in static variable /*uncessary*
        print(convertedPhotoUrl)
        PhotoClient.requestImageFile(sUrl: convertedPhotoUrl, passingPin: selectedPin!, completionHandler: self.handleURLImageResponse(downloadedImage:error:))
       
        //addPhoto(convertedPhotoUrl!)
//        PhotoClient.requestImageFile(sUrl: convertedPhotoUrl!, passingPin: selectedPin!, completionHandler: self.handleURLImageResponse(downloadedImage:error:))
        //print("I returned to createURL after request image call")
        //return
    }
    
//    func addPhoto(_ photoURL: URL) {
//
//
//
//    PhotoClient.requestImageFile(sUrl: photoURL, passingPin: selectedPin!, completionHandler: self.handleURLImageResponse(downloadedImage:error:))
//
////        do {
////             imageData = try Data(contentsOf: photoURL)
////        }
////        catch {
////            print("failure in addPhoto contentsOfData attempt")
////        }
////
////        let persistPhoto = Photo(context: dataController.viewContext)
////        persistPhoto.url = photoURL.description
////       // persistPhoto.image = imageData
////        persistPhoto.creationDate = Date()
////        persistPhoto.latitude = selectedPin.latitude
////        persistPhoto.longitude = selectedPin.longitude
////        photos.append(persistPhoto)
////
////        do {
////            try dataController.viewContext.save()
////        }
////
////        catch let error {
////            print("Failed to save photo in addPhoto() because of \(error)")
////
////        }
////
////        DispatchQueue.main.async {
////            print("final reload of collecView")
////            self.collecView.reloadData()
////        }
////
////        return
//    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    //*************** CollecView *******************
    func numberOfSections(in collectionView: UICollectionView) -> Int { //****************
        return 1 //1 section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // ****************
        let width = (view.frame.width - 20)/3
        return CGSize(width: width, height: 100) //3 cells per width on iphone xs
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("number of photos when initially called: \(photos.count)")
        return photos.count //uses photos entity photos array
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //*********************
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photocell", for: indexPath) as! photoCollectionCell
        
        guard photos[indexPath.row].image != nil else {
            
            cell.cellView.image = nil
            return cell
        }
        if photos[indexPath.row].image != nil {
        cell.cellView.image = UIImage(named: "VirtualTourist_120") // default image first load
        
        
        
        cell.cellView.image = UIImage(data: (photos[indexPath.row].image!)) //assinging image
        }
        
    
    
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
    
    @IBAction func NewCollectionButton(_ sender: Any) { //This is going to empty coreData photos array and recall

    //Delete from CoreData code
        print(photos.count)
        for i in 0..<photos.count {
            self.dataController.viewContext.delete(photos[i])
            //try? dataController!.viewContext.save()
            
            do {
                try self.dataController.viewContext.save()
                //photos.removeAll()
               // self.collecView.reloadData()
            }
            catch {
                print("There was error deleting")
                return
            }
        }
        photos.removeAll()
        collecView.reloadData()
            PhotoClient.getPhotos(selectedPin, completion: self.handlePhotoResponse(success: error:))
        
        print(photos.count)
        self.collecView.reloadData()
        return
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }


    func handleURLImageResponse(downloadedImage: UIImage?, error: Error?) {//**************
        
        var imageData = UIImage(named: "VirtualTourist_120")?.jpegData(compressionQuality: 0.1)
        
        
        if downloadedImage == nil {
            print("download is nil")
        }

        if downloadedImage != nil {
            imageData = downloadedImage!.jpegData(compressionQuality: 0.5)
        }
        else {
            print("There was an error with assigning image to imageData)")
        }
        print("download response reached")
        print("&&&&&&&&&&&&&&&&&&&&")
        let persistPhoto = Photo(context: dataController.viewContext)
        persistPhoto.url = PhotoAlbumController.convertUrl.description
        print(persistPhoto.url)
        persistPhoto.image = imageData
        print(persistPhoto.image)
        persistPhoto.creationDate = Date()
        print(persistPhoto.creationDate)
        persistPhoto.latitude = selectedPin.latitude
        print(persistPhoto.latitude)
        persistPhoto.longitude = selectedPin.longitude
        print(persistPhoto.longitude)
        persistPhoto.pin = selectedPin
        photos.append(persistPhoto)
        
        
        print("&&&&&&&&&&&&&&&&&&&&&&")
      //  photos.insert(persistPhoto, at: 0)

//        try? dataController.viewContext.save()


        do {
            print("saving")
            try self.dataController.viewContext.save()
        }

        catch let error {
            print("Failed to save photo in addPhoto() because of \(error)")

        }
        
        DispatchQueue.main.async {
            print("final reload of collecView")
            self.collecView.reloadData()
        }
        return
    }

//    func addPhotos() { //***************************
//        let photo = Photo(context: dataController.viewContext)
//        photo.creationDate = Date()
//         PhotoClient.getPhotos(completion: self.handlePhotoResponse(success: error:))
//    }


}
