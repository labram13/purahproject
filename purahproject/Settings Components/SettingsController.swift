//
//  SettingsController.swift
//  purahproject
//
//  Created by vinh on 6/3/24.
//

import Foundation
import UIKit

class SettingsController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func downloadPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Download Game Data?", message: "This will save all game data locally and allow you to use the app offline. You will need to download again if there are any updates to the game to get the latest data.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.downloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAllData(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete App Data?", message: "This will delete your diary entries, to-dos, and saved game data.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.deleteAllData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    private func deleteAllData() {
        var URLs: [URL] = []
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            URLs.append(dir.appendingPathComponent("diary.json"))
            URLs.append(dir.appendingPathComponent("monsters.json"))
            URLs.append(dir.appendingPathComponent("creatures.json"))
            URLs.append(dir.appendingPathComponent("materials.json"))
            URLs.append(dir.appendingPathComponent("equipment.json"))
            URLs.append(dir.appendingPathComponent("treasure.json"))
            for fileURL in URLs {
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        try FileManager.default.removeItem(at: fileURL)
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        UserDefaults.standard.removeObject(forKey: "items")
        UserDefaults.standard.synchronize()
    }
    
    private func downloadData() {
        var URLs: [String: String] = [:]
        URLs["monsters"] = "https://botw-compendium.herokuapp.com/api/v3/compendium/category/monsters?game=1"
        URLs["creatures"] = "https://botw-compendium.herokuapp.com/api/v3/compendium/category/creatures?game=1"
        URLs["materials"] = "https://botw-compendium.herokuapp.com/api/v3/compendium/category/materials?game=1"
        URLs["equipment"] = "https://botw-compendium.herokuapp.com/api/v3/compendium/category/equipment?game=1"
        URLs["treasure"] = "https://botw-compendium.herokuapp.com/api/v3/compendium/category/treasure?game=1"
        
        for (category, url) in URLs {
            DispatchQueue.global(qos: .background).async {
                guard let url = URL(string: url) else {
                    NSLog("Invalid URL")
                    return
                }
                
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        NSLog("Error! \(error)")
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode),
                          let data = data else {
                        NSLog("Error! \(String(describing: response))")
                        return
                    }
                    
                    do {
                        // Decode the JSON into the expected structure
                        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                            var fileURL: URL = dir.appendingPathComponent("\(category).json")
                            try data.write(to: fileURL)
                                print("File saved successfully at \(fileURL)")
                        }
                    } catch {
                        NSLog("Error: \(error)")
                    }
                }
                task.resume()
                NSLog("Task resumed")
            }
        }
    }
    
}
