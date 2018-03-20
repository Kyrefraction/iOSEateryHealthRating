//
//  SearchResultsViewController.swift
//  Assignment
//
//  Created by Vincenzo Scialpi-Sullivan on 19/03/2018.
//  Copyright © 2018 Vincenzo Scialpi-Sullivan. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchTermsDisplay: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    var allBusinesses = [CompanyName]()
    var urlOperation: String = ""
    var searchTerms: String = ""
    var originalTerms: String = ""
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // function for returning the cell to populate the tableView
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyBusinessTableViewCell // set the custom cell to be an instance of 'MyBusinessTableViewCell'
        let nameOfBusiness = allBusinesses[indexPath.row].BusinessName // get the name of the business from the array with index of the current row
        var locationOfBusiness = allBusinesses[indexPath.row].AddressLine3
        if locationOfBusiness == "" {
            locationOfBusiness = allBusinesses[indexPath.row].AddressLine2
        }
        cell.businessNameLabelSearch.text = nameOfBusiness + " | " + locationOfBusiness// give the label the name of the business
        let intRating = Int(allBusinesses[indexPath.row].RatingValue) // cast to integer the 'RatingValue' from the array, this is so we can perform numerical operators instead of String operators (the rating is just a number 1 to 5 so this can be easily cast to int)
        let stringRating = allBusinesses[indexPath.row].RatingValue
        if(intRating == 0) { // if the value of intRating is 0
            cell.ratingImageSearch.image = UIImage.init(imageLiteralResourceName: "fhrs_0_en-gb.jpg") // then display the image showing a 0 hygiene rating
        } else if(intRating == 1) { // if the value of intRating is 1
            cell.ratingImageSearch.image = UIImage.init(imageLiteralResourceName: "fhrs_1_en-gb.jpg") // then display the image show a hygiene rating of 1 and so on...
        } else if(intRating == 2) {
            cell.ratingImageSearch.image = UIImage.init(imageLiteralResourceName: "fhrs_2_en-gb.jpg")
        } else if(intRating == 3) {
            cell.ratingImageSearch.image = UIImage.init(imageLiteralResourceName: "fhrs_3_en-gb.jpg")
        } else if(intRating == 4) {
            cell.ratingImageSearch.image = UIImage.init(imageLiteralResourceName: "fhrs_4_en-gb.jpg")
        } else if(intRating == 5) {
            cell.ratingImageSearch.image = UIImage.init(imageLiteralResourceName: "fhrs_5_en-gb.jpg")
        } else if(intRating == -1) { // SPECIAL CASE, if a -1 is returned from the RatingValue in the array
            cell.ratingImageSearch.image = UIImage.init(imageLiteralResourceName: "fhrs_exempt_en-gb.jpg") // then show that it is exempt from the hygiene rating
        } else if(stringRating == "Improvement Required") {
            cell.ratingImageSearch.image = UIImage.init(imageLiteralResourceName: "fhrs_0_en-gb.jpg") // then display the image showing a 0 hygiene rating
        }
        //LEGACY IF CUSTOM CELL DOESN'T WORK DO THIS cell.textLabel?.text = allBusinesses[indexPath.row].BusinessName + " | Rating: " + allBusinesses[indexPath.row].RatingValue
        return cell // return the cell object to populate the table view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // this function returns the number of businesses in the array
        return allBusinesses.count // return size of array allBusinesses
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        searchTermsDisplay.text = "Search for: \(originalTerms)"
        //http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_name&name=Wok%20This%20Way
        if(urlOperation == "s_name") {
            let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=\(urlOperation)&name=\(searchTerms)") // URL to get JSON data from
            URLSession.shared.dataTask(with: url!) {(data, response, error) in // configure the URLSession
                guard let data = data else { print("error with data"); return}
                do {
                    self.allBusinesses = try JSONDecoder().decode([CompanyName].self, from: data); //convert the JSON to an xcode object 'Company' (the JSON data and the attributes of the company object are in the same format, see "Company.swift" to view the object
                    DispatchQueue.main.async {  // interupt the main thread and upate the table with the retrieved data
                        self.myTableView.reloadData();
                    }
                } catch let err {
                    print("error:", err)
                }
                }.resume() // start the network call
            // Do any additional setup after loading the view.
        } else {
            let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=\(urlOperation)&postcode=\(searchTerms)") // URL to get JSON data from
            URLSession.shared.dataTask(with: url!) {(data, response, error) in // configure the URLSession
                guard let data = data else { print("error with data"); return}
                do {
                    self.allBusinesses = try JSONDecoder().decode([CompanyName].self, from: data); //convert the JSON to an xcode object 'Company' (the JSON data and the attributes of the company object are in the same format, see "Company.swift" to view the object
                    DispatchQueue.main.async {  // interupt the main thread and upate the table with the retrieved data
                        self.myTableView.reloadData();
                    }
                } catch let err {
                    print("error:", err)
                }
                }.resume() // start the network call
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // function for showing the details once a company is selected
        if let cell = sender as? UITableViewCell {
            let i = myTableView.indexPath(for: cell)!.row
            if segue.identifier == "details" { // if this is a segue to details
                let dvc = segue.destination as! CompanyDetailsViewController // set the destination to be CompanyDetailsViewController, which is the right controller for the following view
                dvc.currentCompanySearched = self.allBusinesses[i] // the currentCompany object (from CompanyDetailsViewController) is set to the Company object that has been selected in the tableView from the array
                dvc.comingFromSearch = 1
            }
        }
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
