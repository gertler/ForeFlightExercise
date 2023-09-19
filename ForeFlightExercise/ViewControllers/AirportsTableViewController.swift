//
//  AirportsTableViewController.swift
//  ForeFlightExercise
//
//  Created by Harrison Gertler on 9/18/23.
//

import UIKit

class AirportsTableViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: - Properties
    
    private var airports: [String]?
    private var searchController: UISearchController?
    
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
        // Instantiate Search Controller
        // NOTE: This has to be passed nil to make sure self isn't removed from view hierarchy, which causes a black screen
        self.searchController = UISearchController(searchResultsController: nil)
        
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
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AirportTableViewCell.reuse, for: indexPath)

        // Configure the cell...
        var content = cell.defaultContentConfiguration()
        content.text = "Airport Code"
        content.secondaryText = "Airport Other Information"
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetails", sender: self)
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
        guard let row = tableView.indexPathForSelectedRow?.row,
              let _airports = self.airports else {
            return
        }
        vc.airport = _airports[row]
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO: Implement
        guard let _airports = self.airports,
              let searchText = searchController.searchBar.text else {
            return
        }
        
        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        
        _airports.filter({ $0.contains(trimmed)})
        
        return
    }
    

}
