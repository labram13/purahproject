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
    
    private var fileURL: URL? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return dir.appendingPathComponent("treasure.json")
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FileManager.default.fileExists(atPath: fileURL!.path) {
            treasureData = HandleData<Treasure>(fileURL!)
            self.treasureData.data.sort { $0.name.lowercased() < $1.name.lowercased() }
            self.treasureTableView.reloadData()
        } else {
            treasureData = HandleData<Treasure>("https://botw-compendium.herokuapp.com/api/v3/compendium/category/treasure?game=1")
            treasureData.fetch { [weak self] in
                DispatchQueue.main.async {
                    self?.treasureData.data.sort { $0.name.lowercased() < $1.name.lowercased() }
                    self?.treasureTableView.reloadData()
                    // Debugging: Verify data fetch
                    if let equipment = self?.treasureData.data {
                        print("Fetched \(equipment.count) treasures")
                    }
                }
            }
        }

        treasureTableView.dataSource = self
        treasureTableView.delegate = self
        
        assignbackground()
        
    }
    func assignbackground(){
            let background = UIImage(named: "wallpaper")

            var imageView : UIImageView!
            imageView = UIImageView(frame: view.bounds)
            imageView.contentMode =  UIView.ContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = background
            imageView.center = view.center
            view.addSubview(imageView)
            self.view.sendSubviewToBack(imageView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = treasureData.data.count
        NSLog("Number of rows in section: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
