//
//  MaterialViewController.swift
//  purahproject
//
//  Created by Audrey Kim on 6/3/24.
//

import UIKit

class MaterialViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    
    @IBOutlet weak var materialTableView: UITableView!
    var materialData: HandleData<Material>!
    
    private var fileURL: URL? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return dir.appendingPathComponent("treasure.json")
        }
        return nil
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if  FileManager.default.fileExists(atPath: fileURL!.path) {
            materialData = HandleData<Material>(fileURL!)
            self.materialData.data.sort { $0.name.lowercased() < $1.name.lowercased() }
            self.materialTableView.reloadData()
        } else {
            materialData = HandleData<Material>("https://botw-compendium.herokuapp.com/api/v3/compendium/category/materials")
            materialData.fetch { [weak self] in
                DispatchQueue.main.async {
                    self?.materialData.data.sort { $0.name.lowercased() < $1.name.lowercased() }
                    self?.materialTableView.reloadData()
                    // Debugging: Verify data fetch
                    if let materials = self?.materialData.data {
                        print("Fetched \(materials.count) treasures")
                    }
                }
            }
        }

        materialTableView.dataSource = self
        materialTableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = materialData.data.count
        NSLog("Number of rows in section: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("Configuring cell for row at index: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "treasureCell", for: indexPath) as! TableViewCell
        let material = materialData.data[indexPath.row]
        cell.materialNameLabel.text = material.name.capitalized
        if let imageUrl = URL(string: material.image) {
            cell.materialImage.loadImage(from: imageUrl)
        } else {
            NSLog("Invalid URL string: \(material.image)")
        }
        return cell
    }
    // UITableViewDelegate method to set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Set the desired row height
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMaterial" {
            if let indexPath = materialTableView.indexPathForSelectedRow {
                if let destination = segue.destination as? DetailsViewController {
                    let selectedMaterial = materialData.data[indexPath.row]
                    destination.material = selectedMaterial
                }
            }
        }
        
    }

     

}
