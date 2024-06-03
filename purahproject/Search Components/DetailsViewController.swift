import UIKit

class TopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        guard let text = self.text else {
            super.drawText(in: rect)
            return
        }
        
        let textRect = text.boundingRect(
            with: CGSize(width: rect.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: self.font!],
            context: nil
        )
        
        super.drawText(in: CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: textRect.height))
    }
}

class DetailsViewController: UIViewController {
    var monster: Monster?
    var equipment: Equipment?
    var material: Material?
    var creature: Creature?
    var treasure: Treasure?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var locationsLabel: UITextView!
    @IBOutlet weak var detailsTitleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var locationsTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nameSize = nameLabel.font.pointSize
           nameLabel.font = UIFont(name: "HyliaSerifBeta-Regular", size: nameSize)
        let detailsSize = detailsTitleLabel.font.pointSize
           detailsTitleLabel.font = UIFont(name: "HyliaSerifBeta-Regular", size: detailsSize)
        let locationsSize = locationsTitleLabel.font.pointSize
           locationsTitleLabel.font = UIFont(name: "HyliaSerifBeta-Regular", size: locationsSize)
        
        if let monster = monster {
            nameLabel.text = monster.name.capitalized
            descriptionLabel.text = monster.description
            if let locations = monster.common_locations { let joinedLocations = locations.joined(separator: "\n")
                    locationsLabel.text = joinedLocations
            } else {
                locationsLabel.text = "Unknown"
            }
            detailsTitleLabel.text = "Drops"
            if let drops = monster.drops {
                let joinedDrops = drops.joined(separator: "\n")
                if joinedDrops.isEmpty {
                    detailsLabel.text = "None"

                } else {
                    detailsLabel.text = joinedDrops.capitalized
                }
            } else {
                detailsLabel.text = "None"
            }
            if let imageUrl = URL(string: monster.image) {
                imageView.loadImage(from: imageUrl)
            }
            
        } else if let equipment = equipment {
            print(equipment)
            nameLabel.text = equipment.name.capitalized
            if let imageUrl = URL(string: equipment.image) {
                imageView.loadImage(from: imageUrl)
            }
            descriptionLabel.text = equipment.description
            if let locations = equipment.common_locations { let joinedLocations = locations.joined(separator: "\n")
                    locationsLabel.text = joinedLocations
            } else {
                locationsLabel.text = "Unknown"
            }
            detailsTitleLabel.text = "Weapon Stats"
            var weaponStats = ""
                    
            if let attack = equipment.properties.attack {
                weaponStats += "Attack: \(attack)\n"
            } else {
                weaponStats += "Attack: 0\n"
            }
            
            if let defense = equipment.properties.defense {
                weaponStats += "Defense: \(defense)\n"
            } else {
                weaponStats += "Defense: 0\n"
            }
            detailsLabel.text = weaponStats
            
        } else if let material = material {
           
        } else if let creature = creature {
         
        } else if let treasure = treasure {
           
        } else {
            NSLog("No data")
        }
    }

    
    
    @IBAction func handleDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
