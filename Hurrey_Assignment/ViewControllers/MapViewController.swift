//
//  MapViewController.swift
//  Hurrey_Assignment
//
//  Created by Nuthan Raju Pesala on 15/07/20.
//  Copyright © 2020 Nuthan Raju Pesala. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils

/// Point of Interest Item which implements the GMUClusterItem protocol.
class POIItem: NSObject, GMUClusterItem {
    
  var position: CLLocationCoordinate2D
  var name: String!
 

    init(position: CLLocationCoordinate2D, name: String) {
    self.position = position
    self.name = name
   
  }
}

class MapViewController: UIViewController, GMUClusterManagerDelegate,
GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    private var clusterManager: GMUClusterManager!
    
    //true - marker clustering / false - map markers without clustering
    var isClustering : Bool = false
    
    //true - images / false - default icons
    let isCustom : Bool = false
    
    
    var latitude = Double()
    var longitude = Double()
    var studentName = String()
    var mobile = String()
    
    var studentData = [Student]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Map View"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backicon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handledismiss))
        navigationItem.leftBarButtonItem?.tintColor = .gray
        
        if isClustering {
            var iconGenerator : GMUDefaultClusterIconGenerator!
            if isCustom {
                var images : [UIImage] = []
                for imageID in 1...5 {
                    images.append(UIImage(named: "m\(imageID).png")!)
                }
                iconGenerator = GMUDefaultClusterIconGenerator(buckets: [ 10, 50, 100, 200, 500 ], backgroundImages: images)
            } else {
                iconGenerator = GMUDefaultClusterIconGenerator()
            }
            
            let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
            let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
            
            clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
            if studentData.count != 0 {
                generateCoord(isCluster: true, array: studentData)
            }
            
            // Call cluster() after items have been added to perform the clustering and rendering on map.
            clusterManager.cluster()
            
            // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
            clusterManager.setDelegate(self, mapDelegate: self)
            mapView.delegate = self
        } else {
            
            let cameraPosition = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: 6.0)
            mapView.camera = cameraPosition
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placemarks, error) in
                // Process Response
                if let error = error {
                    print("Unable to Reverse Geocode Location (\(error))")
                } else {
                    if let placemarks = placemarks, let placemark = placemarks.first {
                        
                        self.showMarker(position: cameraPosition.target, city:  placemark.locality! + "," + placemark.subLocality!, studentName: self.studentName, phNumber: self.mobile)
                        
                    }
                }
            }
        }
        
    }
    // MARK: - This function will call for particular group students to show on map -
    
    func generateCoord(isCluster: Bool, array: [Student]) {
        
        for count in array {
            let cameraPosition = GMSCameraPosition(latitude: Double(count.latitude!)!, longitude: Double(count.longitude!)!, zoom: 6.0)
            mapView.camera = cameraPosition
            let position = CLLocationCoordinate2D(latitude: Double(count.latitude!)!, longitude: Double(count.longitude!)!)
            
            let item = POIItem(position: position, name: "\((count.name ?? "") + "," + (count.mobile ?? ""))")
            
            clusterManager.add(item)
        }
        
    }
    
    private func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
    }
    
    //Show the marker title while tapping
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let item : POIItem = marker.userData as? POIItem {
            
            marker.title = item.name
            
            marker.position = item.position
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude: item.position.latitude, longitude: item.position.longitude)) { (placemarks, error) in
                // Process Response
                if let error = error {
                    print("Unable to Reverse Geocode Location (\(error))")
                } else {
                    if let placemarks = placemarks, let placemark = placemarks.first {
                        
                        marker.snippet = placemark.locality! + "," + placemark.subLocality!
                        
                    }
                }
                mapView.selectedMarker = marker
            }
        }
        return true
    }
    
  // MARK: - This function will call for particular single student to show on map -
    
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
