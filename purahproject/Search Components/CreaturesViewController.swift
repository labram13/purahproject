//
//  CreaturesViewController.swift
//  purahproject
//
//  Created by Audrey Kim on 6/3/24.
//

import UIKit

class CreaturesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var creaturesTableView: UITableView!
    var creatureData: HandleData<Creature>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatureData = HandleData<Creature>("https://botw-compendium.herokuapp.com/api/v3/compendium/category/creatures")
        creatureData.fetch { [weak self] in DispatchQueue.main.async {
                self?.creatureData.data.sort { $0.name.lowercased() < $1.name.lowercased() }
                self?.creaturesTableView.reloadData()
                // Debugging: Verify data fetch
                if let creatures = self?.creatureData.data {
                    print("Fetched \(creatures.count) monsters")
                }
            }
        }
        creaturesTableView.dataSource = self
        creaturesTableView.delegate = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = creatureData.data.count
        NSLog("Number of rows in section: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("Configuring cell for row at index: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "creatureCell", for: indexPath) as! TableViewCell
        let creature = creatureData.data[indexPath.row]
        cell.creatureNameLabel.text = creature.name.capitalized
        
        if let imageUrl = URL(string: creature.image) {
            cell.creatureImage.loadImage(from: imageUrl)
        } else {
            NSLog("Invalid URL string: \(creature.image)")
        }
        return cell
    }

    // UITableViewDelegate method to set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Set the desired row height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCreature" {
            if let indexPath = creaturesTableView.indexPathForSelectedRow {
                if let destination = segue.destination as? DetailsViewController {
                    let selectedCreature = creatureData.data[indexPath.row]
                    destination.creature = selectedCreature
                }
            }
        }
        
    }

}
