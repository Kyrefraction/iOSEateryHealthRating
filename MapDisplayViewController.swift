//
//  MapDisplayViewController.swift
//  Assignment
//
//  Created by Vincenzo Scialpi-Sullivan on 13/03/2018.
//  Copyright © 2018 Vincenzo Scialpi-Sullivan. All rights reserved.
//

import UIKit
import MapKit

class MapDisplayViewController: UIViewController, MKMapViewDelegate {
    var allEstablishMents = [Company]()
    var personLatitude: String = ""
    var personLongitude: String = ""
    @IBOutlet weak var myMapDisplayMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let sourceLat = (Double(personLatitude)!)
        let sourceLong = (Double(personLongitude)!)
        myMapDisplayMapView.delegate = self
        let span :MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        let location :CLLocationCoordinate2D = CLLocationCoordinate2DMake(sourceLat,sourceLong)
        let region :MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        myMapDisplayMapView.setRegion(region, animated: true)
        myMapDisplayMapView.mapType = .standard
        
        let sourceLocation = customPin()
        sourceLocation.coordinate = location
        sourceLocation.title = "Current Location"
        sourceLocation.image = UIImage(named: "personResized1")
        myMapDisplayMapView.addAnnotation(sourceLocation)
        
        for l in allEstablishMents {
            
            let annotation = customPin()
            var companyLat: Double // get the coordinates of company that is being displayed
            var companyLong: Double
            let latString: String = (l.Latitude)
            let longString: String = (l.Longitude)
            companyLat = (Double(latString))!
            companyLong = (Double(longString))!
            annotation.coordinate = CLLocationCoordinate2DMake(companyLat, companyLong)
            annotation.title = l.BusinessName
            annotation.subtitle = l.AddressLine2
            let intRating = Int(l.RatingValue)// cast to integer the 'RatingValue' from the array, this is so we can perform numerical operators instead of String operators (the rating is just a number 1 to 5 so this can be easily cast to int)

            if(intRating == 0) { // if the value of intRating is 0
                annotation.image = UIImage(named: "fhrs_0_en-gb.jpg")
            } else if(intRating == 1) { // if the value of intRating is 1
                annotation.image = UIImage(named: "fhrs_1_en-gb.jpg")
            } else if(intRating == 2) {
                annotation.image = UIImage(named: "fhrs_2_en-gb.jpg")
            } else if(intRating == 3) {
                annotation.image = UIImage(named: "fhrs_3_en-gb.jpg")
            } else if(intRating == 4) {
                annotation.image = UIImage(named: "fhrs_4_en-gb.jpg")
            } else if(intRating == 5) {
                annotation.image = UIImage(named: "fhrs_5_en-gb.jpg")
            } else if(intRating == -1) { // SPECIAL CASE, if a -1 is returned from the RatingValue in the array
                annotation.image = UIImage(named: "fhrs_exempt_en-gb.jpg")
            }
            myMapDisplayMapView.addAnnotation(annotation)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of:MKUserLocation.self) else { return nil }
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        let customPointAnnotation = annotation as! customPin
        annotationView!.image = customPointAnnotation.image
        return annotationView
    }
}
