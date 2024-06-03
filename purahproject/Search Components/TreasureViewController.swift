//
//  TreasureViewController.swift
//  purahproject
//
//  Created by Audrey Kim on 6/3/24.
//

import UIKit

class TreasureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var treasureTableView: UITableView!
    var treasureData: HandleData<Treasure>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        treasureData = HandleData<Treasure>("https://botw-compendium.herokuapp.com/api/v3/compendium/category/treasure")
        treasureData.fetch { [weak self] in DispatchQueue.main.async {
                self?.treasureData.data.sort { $0.name.lowercased() < $1.name.lowercased() }
                self?.treasureTableView.reloadData()
                // Debugging: Verify data fetch
                if let treasure = self?.treasureData.data {
                    print("Fetched \(treasure.count) monsters")
                }
            }
        }
        treasureTableView.dataSource = self
        treasureTableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = treasureData.data.count
        NSLog("Number of rows in section: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("Configuring cell for row at index: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "treasureCell", for: indexPath) as! TableViewCell
        let treasure = treasureData.data[indexPath.row]
        cell.treasureNameLabel.text = treasure.name.capitalized
        
        if let imageUrl = URL(string: treasure.image) {
            cell.treasureImage.loadImage(from: imageUrl)
        } else {
            NSLog("Invalid URL string: \(treasure.image)")
        }
        return cell
    }
    // UITableViewDelegate method to set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Set the desired row height
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTreasure" {
            if let indexPath = treasureTableView.indexPathForSelectedRow {
                if let destination = segue.destination as? DetailsViewController {
                    let selectedTreasure = treasureData.data[indexPath.row]
                    destination.treasure = selectedTreasure
                }
            }
        }
        
    }
    

}
