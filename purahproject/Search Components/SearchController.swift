//
//  SearchController.swift
//  purahproject
//
//  Created by Michaelangelo Labrador on 5/22/24.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var monsterButton: UIButton!
    @IBOutlet weak var creatureButton: UIButton!
    @IBOutlet weak var itemsButton: UIButton!
    @IBOutlet weak var weaponsButton: UIButton!
    @IBOutlet weak var treasureButton: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonLabelFonts()
       
}
    
    func setButtonLabelFonts() {
        if let button = monsterButton {
            if let currentFont = button.titleLabel?.font {
                if let customFont = UIFont(name: "HyliaSerifBeta-Regular", size: currentFont.pointSize) {
                    button.titleLabel?.font = customFont
                }
            }
        }
        if let button = creatureButton {
            if let currentFont = button.titleLabel?.font {
                if let customFont = UIFont(name: "HyliaSerifBeta-Regular", size: currentFont.pointSize) {
                    button.titleLabel?.font = customFont
                }
            }
        }
        if let button = itemsButton {
            if let currentFont = button.titleLabel?.font {
                if let customFont = UIFont(name: "HyliaSerifBeta-Regular", size: currentFont.pointSize) {
                    button.titleLabel?.font = customFont
                }
            }
        }
        if let button = weaponsButton {
            if let currentFont = button.titleLabel?.font {
                if let customFont = UIFont(name: "HyliaSerifBeta-Regular", size: currentFont.pointSize) {
                    button.titleLabel?.font = customFont
                }
            }
        }
        if let button = treasureButton {
            if let currentFont = button.titleLabel?.font {
                if let customFont = UIFont(name: "HyliaSerifBeta-Regular", size: currentFont.pointSize) {
                    button.titleLabel?.font = customFont
                }
            }
        }
    }
    

  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
