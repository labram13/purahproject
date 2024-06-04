//
//  DiaryController.swift
//  diaryPPP
//
//  Created by vinh on 5/22/24.
//
import Foundation
import UIKit

protocol DiaryEntryCellDelegate: AnyObject {
    func editEntry(cell: DiaryEntryCell)
    func submitEditEntry(cell: DiaryEntryCell)
    func deleteEntry(cell: DiaryEntryCell)
}

class DiaryEntryCell: UITableViewCell {
    
    weak var delegate: DiaryEntryCellDelegate?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var submitEditButton: UIButton!
    
    @IBAction func editPressed(_ sender: Any) {
        bodyLabel.isHidden = true
        editTextView.isHidden = false
        editButton.isHidden = true
        deleteButton.isHidden = true
        submitEditButton.isHidden = false
        delegate?.editEntry(cell: self)
    }

    @IBAction func editSubmit(_ sender: Any) {
        bodyLabel.isHidden = false
        editTextView.isHidden = true
        editButton.isHidden = false
        deleteButton.isHidden = false
        submitEditButton.isHidden = true
        delegate?.submitEditEntry(cell: self)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        delegate?.deleteEntry(cell: self)
    }
}

struct DiaryEntry: Codable {
    var body : String
    var date : Date
}

class DiaryController: UIViewController, UITableViewDelegate, UITableViewDataSource, DiaryEntryCellDelegate {
    
    @IBOutlet weak var addEntryText: UITextView!
    @IBOutlet weak var addEntryButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let dateFormatter = DateFormatter()
    var entries : [DiaryEntry] = []
    
    private var fileURL: URL? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return dir.appendingPathComponent("diary.json")
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEntries()
        tableView.dataSource = self
        tableView.delegate = self
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let currentFont = addEntryButton.titleLabel?.font {
            let customFont = UIFont(name: "HyliaSerifBeta-Regular", size: currentFont.pointSize)
            addEntryButton.titleLabel?.font = customFont
        } 
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
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
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    private func loadEntries() {
        do {
            if fileURL != nil {
                let data = try Data(contentsOf: fileURL!)
                let decodedEntries = try JSONDecoder().decode([DiaryEntry].self, from: data)
                entries = decodedEntries
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func saveEntries() {
        do {
            if fileURL != nil {
                let data = try JSONEncoder().encode(entries)
                try data.write(to: fileURL!, options: .atomic)
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    @IBAction func addNewEntry(_ sender: Any) {
        if addEntryText.hasText {
            let entryBody : String = addEntryText.text
            let currentDate = Date()
            entries.insert(DiaryEntry(body: entryBody, date: currentDate), at: 0)
            NSLog("body: \(entryBody), date: \(currentDate)")
            tableView.reloadData()
            saveEntries()
            addEntryText.text = ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryEntryCell", for: indexPath) as! DiaryEntryCell
        let entry = entries[indexPath.row]
        cell.dateLabel.text = dateFormatter.string(from: entry.date)
        cell.bodyLabel.text = entry.body
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func editEntry(cell: DiaryEntryCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            cell.editTextView.text = entries[indexPath.row].body
        }

    }

    func submitEditEntry(cell: DiaryEntryCell) {
        NSLog("in submiteditentry")
        NSLog(String(describing: tableView.indexPath(for: cell)))
        if let indexPath = tableView.indexPath(for: cell) {
            NSLog("within submiteditentry")
            NSLog(cell.editTextView.text)
            entries[indexPath.row].body = cell.editTextView.text
            NSLog(String(describing: entries[indexPath.row]))
            tableView.reloadData()
            saveEntries()
        }
        NSLog("out submiteditentry")
    }
    
    func deleteEntry(cell: DiaryEntryCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let alertController = UIAlertController(title: "Delete Entry?", message: "Are you sure you want to delete this diary entry?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.entries.remove(at: indexPath.row)
                self.tableView.reloadData()
                self.saveEntries()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
       
        
    }
    
    
}
