
//
//  TechnologyViewController.swift
//  Capital Pride
//
//  Created by John Cloutier on 4/23/15.
//  Copyright (c) 2015 John Cloutier. All rights reserved.
//

import UIKit

class TechnologyViewController: UITableViewController, UISearchResultsUpdating{
    
    var baseBLO: BaseBLO?
    var technologys: [Technology] = []
    
    var filteredTableData = [Technology]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        baseBLO = BaseBLO()
        technologys = baseBLO!.getAllTechnologys()
        technologys = sorted(technologys){ $0.name.lowercaseString < $1.name.lowercaseString }
        
        println(technologys.count)
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        // Reload the table
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            return technologys.count
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("technologyCell") as! UITableViewCell
        if (self.resultSearchController.active && resultSearchController.searchBar.text != "") {
            cell.textLabel?.text = filteredTableData[indexPath.row].name
            return cell
        }
        else {
            cell.textLabel?.text = technologys[indexPath.row].name
            return cell
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        if(searchController.searchBar.text != ""){
            filteredTableData.removeAll(keepCapacity: false)
            let searchPredicate = NSPredicate(format: "SELF.name CONTAINS[c] %@", searchController.searchBar.text)
            let array = (technologys as NSArray).filteredArrayUsingPredicate(searchPredicate)
            filteredTableData = array as! [Technology]
            self.tableView.reloadData()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TechnologyDetailSegue"
        {
            if let destinationVC = segue.destinationViewController as? TechnologyDetailController{
                let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
                destinationVC.technology = technologys[indexPath.row]
            }
        }
    }
    
    
    
}