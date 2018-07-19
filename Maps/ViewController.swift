//
//  ViewController.swift
//  Maps
//
//  Created by Alberto Martínez Sánchez on 18/7/18.
//  Copyright © 2018 Alberto Martínez Sánchez. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    var locationManager:CLLocationManager!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.isZoomEnabled = true
        self.map.delegate = self
        self.map.mapType = .hybrid
       
        
        determineCurrentLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if locationManager.location != nil{
                currentLocation = locationManager.location
                map.showsUserLocation = true
                locationManager.startUpdatingLocation()
                //markUserLocation()
            }else{
                if CLLocationManager.locationServicesEnabled() {
                    //locationManager.startUpdatingHeading()
                    locationManager.startUpdatingLocation()
                }
            }
        }
        
    }
    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1400
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        //mapView.isHidden = true
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func getNearLocations(){
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(currentLocation,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                print(firstLocation)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                
                                            }
        })
    }


}
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            //            currentLocation = locManager.location
            //            getNearlyLocation()
            if currentLocation == nil {
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if  currentLocation != locations[0] as CLLocation{
            currentLocation = locations[0] as CLLocation
            centerMapOnLocation(currentLocation, mapView: self.map)
            getNearLocations()
        }
    }
}

