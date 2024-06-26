import UIKit

extension UIImageView {
    // create url session pulling and download image
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                NSLog("Error loading image: \(error)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                NSLog("Failed to load image data")
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

class MonsterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var monsterTableView: UITableView!
    
    var monstersData: HandleData<Monster>!
    
    private var fileURL: URL? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return dir.appendingPathComponent("monsters.json")
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FileManager.default.fileExists(atPath: fileURL!.path) {
            monstersData = HandleData<Monster>(fileURL!)
            self.monstersData.data.sort { $0.name.lowercased() < $1.name.lowercased() }
            self.monsterTableView.reloadData()
        } else {
            monstersData = HandleData<Monster>("https://botw-compendium.herokuapp.com/api/v3/compendium/category/monsters?game=1")
            monstersData.fetch { [weak self] in
                DispatchQueue.main.async {
                    self?.monstersData.data.sort { $0.name.lowercased() < $1.name.lowercased() }
                    self?.monsterTableView.reloadData()
                    // Debugging: Verify data fetch
                   
                }
            }
        }
        
        monsterTableView.dataSource = self
        monsterTableView.delegate = self
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
        let count = monstersData.data.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "monsterCell", for: indexPath) as! TableViewCell
        let monster = monstersData.data[indexPath.row]
        cell.monsterNameLabel.text = monster.name.capitalized
        
        if let imageUrl = URL(string: monster.image) {
            cell.monsterImage.loadImage(from: imageUrl)
        } else {
            NSLog("Invalid URL string: \(monster.image)")
        }
        
        return cell
    }
    
    // UITableViewDelegate method to set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Set the desired row height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMonster" {
            if let indexPath = monsterTableView.indexPathForSelectedRow {
                if let destination = segue.destination as? DetailsViewController {
                    let selectedMonster = monstersData.data[indexPath.row]
                    destination.monster = selectedMonster
                }
            }
        }
    }
}
