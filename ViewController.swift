//
//  ViewController.swift
//  Assignment
//
//  Created by Vincenzo Scialpi-Sullivan on 29/01/2018.
//  Copyright © 2018 Vincenzo Scialpi-Sullivan. All rights reserved.
// http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&&lat=53.4808&long=-2.2426
// quest'è un esempio dell'URL, devo usare questo ma cambiare i valori di lat e long.

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var myTableView: UITableView! // IBOutlet for the tableView to interact via the code
    @IBOutlet weak var latLongLabel: UILabel! // IBOutlet to interact with the label via code
    let locationManager = CLLocationManager()
    var allBusinesses = [Company]() // Array to hold all the businesses returned by the server, these are saved as 'Company' objects (see "Company.swift" to view this object)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // this function returns the number of businesses in the array
        return allBusinesses.count // return size of array allBusinesses
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // function for returning the cell to populate the tableView
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyBusinessTableViewCell // set the custom cell to be an instance of 'MyBusinessTableViewCell'
        let nameOfBusiness = allBusinesses[indexPath.row].BusinessName // get the name of the business from the array with index of the current row
        cell.businessNameLabel.text = nameOfBusiness // give the label the name of the business
        let intRating = Int(allBusinesses[indexPath.row].RatingValue) // cast to integer the 'RatingValue' from the array, this is so we can perform numerical operators instead of String operators (the rating is just a number 1 to 5 so this can be easily cast to int)
        if(intRating == 0) { // if the value of intRating is 0
            cell.ratingImage.image = UIImage.init(imageLiteralResourceName: "fhrs_0_en-gb.jpg") // then display the image showing a 0 hygiene rating
        } else if(intRating == 1) { // if the value of intRating is 1
            cell.ratingImage.image = UIImage.init(imageLiteralResourceName: "fhrs_1_en-gb.jpg") // then display the image show a hygiene rating of 1 and so on...
        } else if(intRating == 2) {
            cell.ratingImage.image = UIImage.init(imageLiteralResourceName: "fhrs_2_en-gb.jpg")
        } else if(intRating == 3) {
            cell.ratingImage.image = UIImage.init(imageLiteralResourceName: "fhrs_3_en-gb.jpg")
        } else if(intRating == 4) {
            cell.ratingImage.image = UIImage.init(imageLiteralResourceName: "fhrs_4_en-gb.jpg")
        } else if(intRating == 5) {
            cell.ratingImage.image = UIImage.init(imageLiteralResourceName: "fhrs_5_en-gb.jpg")
        } else if(intRating == -1) { // SPECIAL CASE, if a -1 is returned from the RatingValue in the array
            cell.ratingImage.image = UIImage.init(imageLiteralResourceName: "fhrs_exempt_en-gb.jpg") // then show that it is exempt from the hygiene rating
        }
        //LEGACY IF CUSTOM CELL DOESN'T WORK DO THIS cell.textLabel?.text = allBusinesses[indexPath.row].BusinessName + " | Rating: " + allBusinesses[indexPath.row].RatingValue
        return cell // return the cell object to populate the table view
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // function for showing the details once a company is selected
        if let cell = sender as? UITableViewCell {
            let i = myTableView.indexPath(for: cell)!.row
            if segue.identifier == "details" { // if this is a segue to details
                let dvc = segue.destination as! CompanyDetailsViewController // set the destination to be CompanyDetailsViewController, which is the right controller for the following view
                dvc.currentCompany = self.allBusinesses[i] // the currentCompany object (from CompanyDetailsViewController) is set to the Company object that has been selected in the tableView from the array
            }
        }
        else if segue.identifier == "map" { // if it is the segue to the map
            print("map")
            let dvc = segue.destination as! MapDisplayViewController
            dvc.allEstablishMents = allBusinesses
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // ask for Authorisation from the user
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        // if permission granted configure and start the location manager
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            // trigger didUpdateLocations when device moves more than 50 metres
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
        
        // get location from the phone on startup
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        // show the latitude and longitude of current location to the user on the UILabel
        latLongLabel.text = "latitude: \(latitude!) \nlongitude: \(longitude!)"
        print(latitude!)
        print(longitude!)
        // REVERSE GEO-CODING
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locationManager.location!, completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                let locality = firstLocation?.locality
                let country = firstLocation?.country
                
                self.latLongLabel.text = "\(locality!) \(country!)"
            } else {
                // An error occurred during geocoding.
                if let error = error {
                    print("error with reverse geo-coding \n \(error)")
                }
            }
        })
        
        myTableView.dataSource = self
        myTableView.delegate = self
        let endURL = "lat=\(latitude!)&long=\(longitude!)"
        print(endURL)
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&&" + endURL) // URL to get JSON data from
        print("data retrieved at:" + endURL)
        URLSession.shared.dataTask(with: url!) {(data, response, error) in // configure the URLSession
            guard let data = data else { print("error with data"); return}
            do {
                self.allBusinesses = try JSONDecoder().decode([Company].self, from: data); //convert the JSON to an xcode object 'Company' (the JSON data and the attributes of the company object are in the same format, see "Company.swift" to view the object
                DispatchQueue.main.async {  // interupt the main thread and upate the table with the retrieved data
                    self.myTableView.reloadData();
                }
                //print(self.allBusinesses.count) // print the size of the businesses array
                //print(self.allBusinesses[0].BusinessName) // print the name of the first Company object
            } catch let err {
                print("error:", err)
            }
            }.resume() // start the network call


    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // on update location
        let latitude = locations[0].coordinate.latitude
        let longitude = locations[0].coordinate.longitude
         // latLongLabel.text = "latitude: \(latitude) \nlongitude \(longitude)"
        
        // REVERSE GEO-CODING
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locations[0], completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                if let locality = firstLocation?.locality {
                    if let country = firstLocation?.country {
                        self.latLongLabel.text = "\(locality), \(country)"
                    }
                } else {
                    self.latLongLabel.text = "location details not available"
                }
            } else {
                // An error occurred during geocoding.
                if let error = error {
                    print("error with reverse geo-coding \n\(error)")
                }
            }
        })
        let endURL = "lat=\(latitude)&long=\(longitude)"
        print(endURL)
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&&" + endURL) // URL to get JSON data from
        print("data retrieved at:" + endURL)
        URLSession.shared.dataTask(with: url!) {(data, response, error) in // configure the URLSession
            guard let data = data else { print("error with data"); return}
            do {
                self.allBusinesses = try JSONDecoder().decode([Company].self, from: data); //convert the JSON to an xcode object 'Company' (the JSON data and the attributes of the company object are in the same format, see "Company.swift" to view the object
                DispatchQueue.main.async {  // interupt the main thread and upate the table with the retrieved data
                    self.myTableView.reloadData();
                }
                //print(self.allBusinesses.count) // print the size of the businesses array
                //print(self.allBusinesses[0].BusinessName) // print the name of the first Company object
            } catch let err {
                print("error:", err)
            }
            }.resume() // start the network call

    }
    
}

