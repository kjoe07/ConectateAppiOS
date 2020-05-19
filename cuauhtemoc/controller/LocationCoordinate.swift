//
//  LocationCoordinate.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 5/18/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit
import CoreLocation

class LocationCoordinateDelegate:NSObject,CLLocationManagerDelegate{
    var locationManager: CLLocationManager?
    var updated: ((CLLocationCoordinate2D) -> Void)?
    override init() {
        super.init()
        print("init delegate")
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("auth change")
        switch status {
        case .authorizedWhenInUse,.authorizedAlways:
            locationManager?.startUpdatingLocation()
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("update location")
       // map.clear()
       let location = locations.last! as CLLocation
        updated?(location.coordinate)
        locationManager?.stopUpdatingLocation()
    }
    func requestAuthorization(){
        print("request authorization")
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            locationManager?.startUpdatingLocation()
        }else{
            locationManager?.requestWhenInUseAuthorization()
        }        
    }
    func stopLocation(){
        locationManager?.stopUpdatingLocation()
    }
}

