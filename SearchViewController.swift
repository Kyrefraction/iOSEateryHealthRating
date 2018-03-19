//
//  SearchViewController.swift
//  Assignment
//
//  Created by Vincenzo Scialpi-Sullivan on 07/03/2018.
//  Copyright © 2018 Vincenzo Scialpi-Sullivan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var segmentedSearch: UISegmentedControl!
    @IBAction func searchButton(_ sender: Any) {
        if(segmentedSearch.selectedSegmentIndex == 0) {
            
        } else if(segmentedSearch.selectedSegmentIndex == 1) {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
