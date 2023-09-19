//
//  AirportsTableViewController.swift
//  ForeFlightExercise
//
//  Created by Harrison Gertler on 9/18/23.
//

import UIKit

class AirportsTableViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: - Properties
    
    private var airports: [String] = ["KPWM", "KAUS"]
    private var searchController: UISearchController?
    private var searchResultsTableController: SearchResultsTableViewController!
    
    // MARK: - Overrides
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.register(AirportTableViewCell.self, forCellReuseIdentifier: AirportTableViewCell.reuse)
        self.title = "Airports"
        
        setupSearchController()
    }
    
    // MARK: - Setup Functions
    
    private func setupSearchController() {
        // Instantiate Search Results Table View Controller
        searchResultsTableController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultsTableViewController") as? SearchResultsTableViewController
        searchResultsTableController.tableView.delegate = self
        
        // Instantiate Search Controller
        // NOTE: This has to be passed nil to make sure self isn't removed from view hierarchy, which causes a black screen
        self.searchController = UISearchController(searchResultsController: searchResultsTableController)
        
        // Define delegates and setup
        self.searchController?.delegate = self
        self.searchController?.searchResultsUpdater = self
        self.searchController?.searchBar.autocapitalizationType = .none
        self.searchController?.searchBar.delegate = self
                
        // Add search bar to navigation
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return airports.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AirportTableViewCell.reuse, for: indexPath)

        // Configure the cell...
        var content = cell.defaultContentConfiguration()
        content.text = airports[indexPath.row]
        content.secondaryText = "Airport Other Information"
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "showDetails", sender: self)
//    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAirport: String!
        
        // Check if the selection is from default or search tableView
        if tableView == self.tableView {
            selectedAirport = airports[indexPath.row]
        } else {
            selectedAirport = searchResultsTableController.filteredAirports[indexPath.row]
        }
        
        let detailsViewController = DetailsViewController.createDetailsViewController(selectedAirport)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let vc = segue.destination as? DetailsViewController else {
            return
        }
        guard let row = tableView.indexPathForSelectedRow?.row else {
            return
        }
        vc.airport = airports[row]
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        
        if let resultsController = searchController.searchResultsController as? SearchResultsTableViewController {
            // Update filtered airports to only include matching characters (case insensitive)
            resultsController.filteredAirports = airports.filter({ $0.range(of: trimmed, options: .caseInsensitive) != nil })
            resultsController.tableView.reloadData()
        }

        return
    }
    

}
