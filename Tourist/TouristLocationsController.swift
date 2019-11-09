//
//  TouristLocations.swift
//  Tourist
//
//  Created by Elias Hall on 10/26/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class TouristLocationsController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var pins: [Pin] = [] //saved persisted pin objects
    
    var dataController: DataController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        mapView.delegate = self
        retrieveCoreData()
    }
    
    func retrieveCoreData() { //retrieves persisted pin objects from core data
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false) //pins added in creation date descending order. Most recent and the top.
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? dataController?.viewContext.fetch(fetchRequest) { //fetching persisted pins
            pins = result //storing in pins array for use in class
            
            recreateAnno(pins: pins) //sending pins array containing petched pins to annotation creation
            return
        }
        else {
            print("unable to fetch")
            return
        }
        
    }
    
    func recreateAnno(pins: [Pin]) { //recreates persisted pin annotation
        if !pins.isEmpty { //if there are persisted pins
        for i in 0..<pins.count { //for each pin
            
            let annotation = MKPointAnnotation() //create annotation

            annotation.coordinate = CLLocationCoordinate2D(latitude: pins[i].latitude, longitude: pins[i].longitude) //make annotation's coordinate from pin objects saved lat and long
            mapView.addAnnotation(annotation) //add the new annotation
        }
            return
        }
        else {
            print("There are currently are no persisted pins")
            return
        }
    }
    
    @IBAction func longPressPin(_ sender: UILongPressGestureRecognizer) { //adding annotation
        let annotation = MKPointAnnotation() //creating annotation
        
        let pinView = sender.location(in: self.mapView)//Getting location from tap
        // Add annotation alert with ok and cancel to add annotation
        let alert = UIAlertController(title: "Add", message: "Do you want to add a location?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
            
            annotation.coordinate = self.mapView.convert(pinView, toCoordinateFrom: self.mapView)
            
            self.addPins(annotation)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) in
            return //Don't add pin
        })
        
        alert.addAction(okAction) //adding ok to alert
        alert.addAction(cancelAction) // adding cancel to alert
        
        self.present(alert, animated: true, completion: nil) //Display Alert
        
        self.mapView.addAnnotation(annotation) //Adding Annotation pin to map
    }
    
    
    func addPins(_ passedPin: MKPointAnnotation) { //saving pin to coreData Container
        let pin = Pin(context: dataController!.viewContext) //defining persisted pin attribute data
        pin.creationDate = Date()
        pin.latitude = passedPin.coordinate.latitude
        pin.longitude = passedPin.coordinate.longitude
        try? dataController!.viewContext.save() //saving pin object and it's new attributes
        pins.insert(pin, at: 0) //adding new pin to front of pins array
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushCollec" { //segue used pushes to collectionView
            let key = segue.destination as! PhotoAlbumController //data to be sent to PhotoAlbum Controller
            key.selectedPin = (sender as! Pin)
            key.dataController = dataController
        }
    }
    
    func deletePins() { //delete persisted pins. If want to clear core data. To use add call somewhere.
        for i in 0..<pins.count {
            dataController!.viewContext.delete(pins[i])
            try? dataController!.viewContext.save()
        }
        pins.removeAll()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
  
        let lat = Double(view.annotation?.coordinate.latitude ?? 0)
        let lon = Double(view.annotation?.coordinate.longitude ?? 0)
            
            for pin in pins {
                if pin.latitude == lat && pin.longitude == lon { //condition persisted pin check
            self.performSegue(withIdentifier: "pushCollec", sender: pin ) //segueing and sending selected pin
//            print("\(Thread.current)")
            mapView.deselectAnnotation(view.annotation, animated: false) //deselecting pin so reselect works
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "pinView" //Creating pin
        var annotationImage: MKPinAnnotationView? = nil //pin image setup
        annotationImage = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationImage == nil {
            annotationImage = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)

        } else {
            annotationImage!.annotation = annotation
        }
        return annotationImage
    }
}
