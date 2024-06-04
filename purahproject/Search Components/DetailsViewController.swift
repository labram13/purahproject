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
        let detailItems = detailsLabel.font!.pointSize
        detailsLabel.font = UIFont(name: "HyliaSerifBeta-Regular", size: detailItems)
        let locationsSize = locationsTitleLabel.font.pointSize
           locationsTitleLabel.font = UIFont(name: "HyliaSerifBeta-Regular", size: locationsSize)
        let locationItemSize = locationsLabel.font!.pointSize
           locationsLabel.font = UIFont(name: "HyliaSerifBeta-Regular", size: locationItemSize)
        
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
            nameLabel.text = material.name
            descriptionLabel.text = material.description
            if let imageUrl = URL(string: material.image) {
                imageView.loadImage(from: imageUrl)
            }
            
            if let locations = material.common_locations { let joinedLocations = locations.joined(separator: "\n")
                    locationsLabel.text = joinedLocations
            } else {
                locationsLabel.text = "Unknown"
            }
            
            detailsTitleLabel.text = "Cooking Effect"
            var effectsString = ""
            if let cooking = material.cooking_effect {
                effectsString += "\(cooking)"
            }
            if let hearts = material.hearts_recovered {
                if effectsString.isEmpty {
                    effectsString += "Hearts Recovered: \(String(hearts))"
                } else {
                    effectsString += "\nHearts Recovered: \(String(hearts))"

                }
            }
            detailsLabel.text = effectsString
            
        } else if let creature = creature {
            nameLabel.text = creature.name.capitalized
            descriptionLabel.text = creature.description
            if let imageUrl = URL(string: creature.image) {
                imageView.loadImage(from: imageUrl)
            }
            if let locations = creature.common_locations { let joinedLocations = locations.joined(separator: "\n")
                    locationsLabel.text = joinedLocations
            } else {
                locationsLabel.text = "Unknown"
            }
            if creature.edible {
                // food
                var cooking = ("\(creature.cooking_effect!)\n")
                if let hearts = creature.hearts_recovered {
                    cooking += "Hearts Recovered: \(String(hearts))"
                }
                detailsLabel.text = cooking
                detailsTitleLabel.text = "Effects"
            } else {
                // not food
                if let drops = creature.drops  {
                    detailsTitleLabel.text = "Drops"
                    let joinedDrops = drops.joined(separator: "\n")
                    if joinedDrops.isEmpty {
                        detailsLabel.text = "None"
                    } else {
                        detailsLabel.text = joinedDrops.capitalized
                    }
                    detailsTitleLabel.text = "Drops"
                } else {
                    detailsTitleLabel.text = "Drops"
                    detailsLabel.text = "None"
                }
            }
        } else if let treasure = treasure {
            nameLabel.text = treasure.name.capitalized
            descriptionLabel.text = treasure.description
            if let imageUrl = URL(string: treasure.image) {
                imageView.loadImage(from: imageUrl)
            }
            if let locations = treasure.common_locations { let joinedLocations = locations.joined(separator: "\n")
                    locationsLabel.text = joinedLocations
            } else {
                locationsLabel.text = "Unknown"
            }
            detailsTitleLabel.text = "Drops"
            if let drops = treasure.drops {
                let joinedDrops = drops.joined(separator: "\n")
                if joinedDrops.isEmpty {
                    detailsLabel.text = "None"

                } else {
                    detailsLabel.text = joinedDrops.capitalized
                }
            } else {
                detailsLabel.text = "Unknown"
            }
        } else {
            NSLog("No data")
        }
    }

    
    
    @IBAction func handleDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
