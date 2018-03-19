//
//  CompanyDetailsViewController.swift
//  Assignment
//
//  Created by Vincenzo Scialpi-Sullivan on 05/03/2018.
//  Copyright © 2018 Vincenzo Scialpi-Sullivan. All rights reserved.
//

import UIKit
import MapKit

class CompanyDetailsViewController: UIViewController, MKMapViewDelegate { // This class controls the details view, it takes 'currentCompany' from the tableView in the "viewcontroller.swift"

    @IBOutlet weak var companyName: UILabel! //IBOutlet to control the label, this simply shows the name
    @IBOutlet weak var myDetailsMapView: MKMapView! // IBOutlet for the mapview
    @IBOutlet weak var companyDetails: UILabel! // IBOutlet to show all the information, this is done as one label with newlines (\n) written in the string for simplicity's sake
    var currentCompany: Company? // the current company object, which is an instantiation of the "Company" class
    override func viewDidLoad() {
        super.viewDidLoad()
        myDetailsMapView.delegate = self
        
        var companyLat: Double // get the coordinates of company that is being displayed
        var companyLong: Double
        let latString: String = (currentCompany?.Latitude)!
        let longString: String = (currentCompany?.Longitude)!
        companyLat = (Double(latString)!)
        companyLong = (Double(longString)!)
        
        var personLatitude: String
        var personLongitude: String
        
        let sourceLocation = CLLocationCoordinate2D(latitude: 53.47212, longitude: -2.239928)
        let desinationLocation = CLLocationCoordinate2D(latitude: companyLat, longitude: companyLong)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: desinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = customPin()
        sourceAnnotation.title = "Current Location"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = customPin()
        destinationAnnotation.title = currentCompany?.BusinessName
        destinationAnnotation.subtitle = currentCompany?.AddressLine2
        destinationAnnotation.image = UIImage(named: "foodIcon")
        sourceAnnotation.image = UIImage(named: "personResized1")
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.myDetailsMapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.myDetailsMapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.myDetailsMapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        let span :MKCoordinateSpan = MKCoordinateSpanMake(0.03,0.03)
        let location :CLLocationCoordinate2D = CLLocationCoordinate2DMake(53.47212, -2.239928)
        let region :MKCoordinateRegion = MKCoordinateRegionMake(location,span)
        myDetailsMapView.setRegion(region, animated: true)
        myDetailsMapView.mapType = .standard
        
        
        //showRouteOnMap(pickupCoordinate: annotation.coordinate, destinationCoordinate: annotation2.coordinate)
        
        companyName.text = currentCompany?.BusinessName // set the companyName LABEL to the string taken from the currentCompany object
        var detailsOfCompany: String // declare the string to hold the details of the company
        var distanceOfCompanyMINT: Double // SPECIAL CASE declare a double to store the distance in KM from user's current location, this has to be double as we are going to do some mathematical operations with this number to convert it from Kilometres to Metres. It cannot be a String if we want to perform these operations
        let distOfCompany: String = (currentCompany?.DistanceKM)! // take the distance from the user's location from the object (this is in KM and a string so must be taken as such)
        distanceOfCompanyMINT = (Double(distOfCompany)!) * 1000 // convert the value in KM to a double and multiply by 1000 to convert to metres
        distanceOfCompanyMINT = truncateDouble(places: 2,Number: distanceOfCompanyMINT) // truncate the number to 2 decimal places (this is enough information for the user to accurate understand their distance from the eatery and is standard for showing distances in Metres)
        let distOfCompanyFinalDouble: String = String(distanceOfCompanyMINT) // convert the final value of the distance in Metres back to String to be displayed on the label
        detailsOfCompany = "" + (currentCompany?.AddressLine2)! + "\n" + (currentCompany?.AddressLine3)! + "\n\nRating: " + (currentCompany?.RatingValue)! + "\nThis establishment was last rated: " + (currentCompany?.RatingDate)! + "\n\nDistance: " // create the String using the information taken from the currentCompany object
        detailsOfCompany = detailsOfCompany + distOfCompanyFinalDouble + "M" // add the distance in M finally to the string
        companyDetails.text = detailsOfCompany // give the companyDetails LABEL this string containing all the company information that is relevant
        
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
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.myDetailsMapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            
            self.myDetailsMapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.myDetailsMapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            
            
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        renderer.lineWidth = 5.0
        
        return renderer
    }
    func truncateDouble(places: Int, Number: Double) -> Double // method for truncating a double, takes 2 values (number of decimal places the user wants, the number to truncate)
    {
        return Double(floor(pow(10.0, Double(places)) * Number)/pow(10.0, Double(places))) // returns the truncated number e.g. truncateDouble(2,34.646565) returns 34.64
    }
}
