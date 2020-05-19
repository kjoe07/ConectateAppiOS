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
//            let alert = UIAlertController(title: "Ups!", message: "esta app necesita acceso a tu localización activa la localización para tener una experiencia completa", preferredStyle: .alert)
//            let action = UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
//                self.locationManager?.startUpdatingLocation()
//            })
//            alert.addAction(action)
            //self.present(alert, animated: true, completion: nil)
            //loadHomeData(lat: 0.0, lng: 0.0)
           // addCurrentLocationMarker()
           // startMonitoringLocation()
            
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("update")
       // map.clear()
       let location = locations.last! as CLLocation
        updated?(location.coordinate)
//        let marker = GMSMarker(position: location!.coordinate)
//        marker.icon = #imageLiteral(resourceName: "surcusalesBluew")
//        marker.map = self.map
//        map.camera = GMSCameraPosition(target: location!.coordinate, zoom: 14)
//        print("location acquired:",location ?? CLLocation(latitude: 0, longitude: 0))
//        loadHomeData(lat: location!.coordinate.latitude, lng: location!.coordinate.longitude)
//        map.animate(to: GMSCameraPosition(target: location!.coordinate, zoom: 14))
        locationManager?.stopUpdatingLocation()
        //let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        //self.map.//setRegion(region, animated: true)
    }
    func requestAuthorization(){
        print("request")
        locationManager?.requestWhenInUseAuthorization()
    }
}

