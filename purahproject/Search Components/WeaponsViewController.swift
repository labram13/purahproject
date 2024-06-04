//
//  WeaponsViewController.swift
//  purahproject
//
//  Created by Michaelangelo Labrador on 6/3/24.
//

import UIKit

class WeaponsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var weaponsTableView: UITableView!
    
    var weaponsData: HandleData<Equipment>!
    
    private var fileURL: URL? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return dir.appendingPathComponent("equipment.json")
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FileManager.default.fileExists(atPath: fileURL!.path) {
            weaponsData = HandleData<Equipment>(fileURL!)
            self.weaponsData.data.sort { $0.name.lowercased() < $1.name.lowercased() }
            self.weaponsTableView.reloadData()
        } else {
            weaponsData = HandleData<Equipment>("https://botw-compendium.herokuapp.com/api/v3/compendium/category/equipment?game=1")
            weaponsData.fetch { [weak self] in
                DispatchQueue.main.async {
                    self?.weaponsData.data.sort { $0.name.lowercased() < $1.name.lowercased() }
                    self?.weaponsTableView.reloadData()
                    // Debugging: Verify data fetch
                    if let equipment = self?.weaponsData.data {
                        print("Fetched \(equipment.count) monsters")
                    }
                }
            }
        }
        

        
        weaponsTableView.dataSource = self
        weaponsTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = weaponsData.data.count
        NSLog("Number of rows in section: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("Configuring cell for row at index: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "monsterCell", for: indexPath) as! TableViewCell
        let equipment = weaponsData.data[indexPath.row]
        cell.equipmentNameLabel.text = equipment.name.capitalized
        
        if let imageUrl = URL(string: equipment.image) {
            cell.equipmentImage.loadImage(from: imageUrl)
        } else {
            NSLog("Invalid URL string: \(equipment.image)")
        }
        
        return cell
    }
    
    // UITableViewDelegate method to set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Set the desired row height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEquipment" {
            if let indexPath = weaponsTableView.indexPathForSelectedRow {
                if let destination = segue.destination as? DetailsViewController {
                    let selectedWeapon = weaponsData.data[indexPath.row]
                    destination.equipment = selectedWeapon
                }
            }
        }
    }
}
