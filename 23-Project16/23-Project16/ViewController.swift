//
//  ViewController.swift
//  23-Project16
//
//  Created by Arjun Dureja on 2020-05-01.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Standard", style: .plain, target: self, action: #selector(mapTypeTapped))
        
        title = "Capital Cities"
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    @objc func mapTypeTapped() {
        let ac = UIAlertController(title: "Map Type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: changeType))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: changeType))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: changeType))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    @objc func changeType(_ action: UIAlertAction) {
        switch action.title! {
        case "Standard":
            mapView.mapType = .standard
            navigationItem.rightBarButtonItem?.title = "Standard"
        case "Satellite":
            mapView.mapType = .satellite
            navigationItem.rightBarButtonItem?.title = "Satellite"
        case "Hybrid":
            mapView.mapType = .hybrid
            navigationItem.rightBarButtonItem?.title = "Hybrid"
        default:
            return
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        if let pinView = annotationView as? MKPinAnnotationView {
            pinView.pinTintColor = .blue
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let website = capital.info
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? WebViewController else { return }
        vc.website = website
        vc.capital = placeName
        navigationController?.pushViewController(vc, animated: true)
        
        
    }


}

