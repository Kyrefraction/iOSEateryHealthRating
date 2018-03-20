//
//  SearchViewController.swift
//  Assignment
//
//  Created by Vincenzo Scialpi-Sullivan on 07/03/2018.
//  Copyright © 2018 Vincenzo Scialpi-Sullivan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBAction func searchButton(_ sender: Any) {
        print("search")
    }
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var segmentedSearch: UISegmentedControl!
    var urlOperation: String = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // function for showing the details once a company is selected
            if segue.identifier == "table" { // if this is a segue to details
            let dvc = segue.destination as! SearchResultsViewController // set the destination to be SearchResultsViewController, which is the right controller for the following view
                if(segmentedSearch.selectedSegmentIndex == 0) {
                    urlOperation = "s_name"
                } else if(segmentedSearch.selectedSegmentIndex == 1) {
                    urlOperation = "s_postcode"
                }
                let searchTerms: String = (searchText.text)!
                let escapedSearchTerms = searchTerms.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                dvc.urlOperation = urlOperation
                dvc.searchTerms = escapedSearchTerms!
                dvc.originalTerms = searchTerms
        }
    }
}
