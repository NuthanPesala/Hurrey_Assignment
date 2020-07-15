//
//  MapViewController.swift
//  Hurrey_Assignment
//
//  Created by Nuthan Raju Pesala on 15/07/20.
//  Copyright © 2020 Nuthan Raju Pesala. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var latitude = Double()
    var longitude = Double()
    var studentName = String()
    var mobile = String()
    
    var studentData = [Student]()
    var isFromSchool: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.title = "Map View"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backicon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handledismiss))
               navigationItem.leftBarButtonItem?.tintColor = .gray
        
        if isFromSchool == true {
            let mylocationsArr = studentData
            self.showMultipleMarker(array: mylocationsArr)
        }else {
            let cameraPosition = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: 6.0)
            mapView.camera = cameraPosition
            
            // self.mapView.delegate = self
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placemarks, error) in
                // Process Response
                if let error = error {
                    print("Unable to Reverse Geocode Location (\(error))")
                } else {
                    if let placemarks = placemarks, let placemark = placemarks.first {
                        
                        self.showMarker(position: cameraPosition.target, city:  placemark.locality! + "," + placemark.subLocality!, studentName: self.studentName, phNumber: self.mobile)
                        //self.country = placemark.country!
                    }
                }
            }
        }
    }
    
    
    func showMultipleMarker(array: [Student]) {
        for x in array {
            let cameraPosition = GMSCameraPosition(latitude: Double(x.latitude!)!, longitude: Double(x.longitude!)!, zoom: 6.0)
            mapView.camera = cameraPosition
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake( Double(x.latitude!)!, Double(x.longitude!)!)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude:  Double(x.latitude!)!, longitude: Double(x.longitude!)!)) { (placemarks, error) in
                // Process Response
                if let error = error {
                    print("Unable to Reverse Geocode Location (\(error))")
                } else {
                    if let placemarks = placemarks, let placemark = placemarks.first {
                        
                        marker.snippet = placemark.locality! + "," + placemark.subLocality!
                        
                    }
                }
            }
            let name = x.name
            let mobile = x.mobile
            marker.title = name! + "," + mobile!
            marker.map = self.mapView
            
        }
    }
    
    func showMarker(position: CLLocationCoordinate2D, city: String, studentName: String, phNumber: String) {
        let marker = GMSMarker()
        marker.position = position
        marker.map = mapView
        marker.title = studentName + "," + phNumber
        marker.snippet = city
    }

    @objc func handledismiss() {
          self.navigationController?.popViewController(animated: true)
      }
  

}
