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
    
    static var myAnnotations: [MKAnnotation] = [] //holding all annotations
    var pins: [Pin] = []
    
    var dataController: DataController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        mapView.delegate = self
        retrieveCoreData()
        
    }
    
    func retrieveCoreData() {
        print("Inside retrieveCoreData")
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor] //returning objects in order of creation date
        
        //predicate used to filter results
        
        if let result = try? dataController?.viewContext.fetch(fetchRequest) {
            pins = result
            
            print("******************** \(pins)")
            addPinMap(pins: pins)
            return
        }
        else {
            print("unable to fetch")
            return
        }
  
    }
    
    func addPinMap(pins: [Pin]) {
        if !pins.isEmpty {
            print("There is a pin")
        for i in 0..<pins.count {
            print(pins.count)
            let annotation = MKPointAnnotation()
          //  annotation.coordinate.latitude = pins[i].latitude
            //annotation.coordinate.longitude = pins[i].longitude
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: pins[i].latitude, longitude: pins[i].longitude)
            print("$$$$$$$ \(annotation.coordinate)")
            mapView.addAnnotation(annotation)
//            if pins[i].annotationKey == nil { continue }
//            mapView.addAnnotation(pins[i].annotationKey as! MKPointAnnotation)
        }
            return
        }
        else {
            print("There is no pin")
            return
        }
    }
    
    func viewDidAppear() {
        mapView.removeAnnotations(TouristLocationsController.myAnnotations)
        //        mapView.addAnnotations(TravelLocationsController.myAnnotations)
    }
    
    func addPins(_ passedPin: MKPointAnnotation) { //saving pin to coreData Container
        let pin = Pin(context: dataController!.viewContext)
        pin.annotationKey = AdditionalDataStruct.annotationPinKey
        pin.creationDate = Date()
        pin.latitude = passedPin.coordinate.latitude
        pin.longitude = passedPin.coordinate.longitude
//        pin.latitude = CoordinateStruct.latitude
//        pin.longitude = CoordinateStruct.longitude
        print("^^^^^^^^^^^")
        print(pin.longitude)
        print(pin.latitude)
        print("^^^^^^^^^^^")
        try? dataController!.viewContext.save()
        pins.insert(pin, at: 0)
       // pins.append(pin)
        //pins.insert(pin, at: 0)
    }
    
    func deletePins(_ passedPin: MKPointAnnotation) {
        //let pin = Pin(context: dataController!.viewContext)
        for i in 0..<pins.count {
        dataController!.viewContext.delete(pins[i])
        try? dataController!.viewContext.save()
        }
    }
    
    @IBAction func longPressPin(_ sender: UILongPressGestureRecognizer) { //adding annotation
        
        let annotation = MKPointAnnotation() //creating annotation
        
        let pinView = sender.location(in: self.mapView)//Getting location from tap
        let alert = UIAlertController(title: "Add", message: "Do you want to add a location?", preferredStyle: .alert)
        
        //OK Action is being called after code below that is why addpin isnt working, try adding completion handler to okaction.
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
    
            //getting coordinates from tapped location assigning in pinCoordinate
            let pinCoordinate = self.mapView.convert(pinView, toCoordinateFrom: self.mapView)
            
            //Assigning in static var in CoordinateStruct. another option is to create a non static pin object and give it long and lat properties.
            CoordinateStruct.latitude = pinCoordinate.latitude
            CoordinateStruct.longitude = abs(pinCoordinate.longitude)
            print("&&&&&&&&&&\(CoordinateStruct.latitude)... \(CoordinateStruct.longitude)")
            
            annotation.coordinate = pinCoordinate //Giving pin annotation it's coordinates
            self.addPins(annotation)
           // self.deletePins(annotation)
            
            print("$$$$$$$$$$$ \(annotation.coordinate.latitude), \(annotation.coordinate.longitude)")

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) in
            return //Don't add pin
        })
        
        alert.addAction(okAction) //adding ok to alert
        alert.addAction(cancelAction) // adding cancel to alert
        
        self.present(alert, animated: true, completion: nil) //Display Alert
                
        //Add Pin Alert ********************
        TouristLocationsController.myAnnotations.append(annotation) //storing annotations for Core Data
        self.mapView.addAnnotation(annotation) //Adding Annotation pin to map
        
    }
    
    //**********
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)

        print("^^^^^: \(Thread.current)")
        
        //let test = String(view.annotation! as! String)
        
        let test = view.annotation?.description
        print("********#########$$$$$$$\(test!)")
        print(type(of: test!))

        let lat = Double(view.annotation?.coordinate.latitude ?? 0)
        let lon = Double(view.annotation?.coordinate.longitude ?? 0)
            
            for pin in pins {
                if pin.latitude == lat && pin.longitude == lon {
            self.performSegue(withIdentifier: "pushCollec", sender: pin ) //if yes pass true
            print("$$$$$$$$This is the tread: \(Thread.current)")
            mapView.deselectAnnotation(view.annotation, animated: false)

            }
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        //view.annotation.
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
        print("Made it 1")
        if segue.identifier == "pushCollec" {
            print("Made it 2")
            let key = segue.destination as! PhotoAlbumController
//            key.selectedPin = (sender as! Pin)
            key.selectedPin = (sender as! Pin)
            print("Made it 3")
            key.dataController = dataController
            
        }
    }
    
    
    func didSelectHandler() {
        //        mapView.deselectAnnotation(view.annotation, animated: false)
        DispatchQueue.global().sync{
            self.mapView.removeAnnotations(TouristLocationsController.myAnnotations)
            self.mapView.addAnnotations(TouristLocationsController.myAnnotations)
            
            return
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "pinView" //Creating pin
        var annotationImage: MKPinAnnotationView? = nil
        annotationImage = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationImage == nil {
            annotationImage = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            //            annotationImage!.canShowCallout = true
            //            annotationImage!.annotation?.title = "Location"
        } else {
            annotationImage!.annotation = annotation
        }
        return annotationImage
    }
}
