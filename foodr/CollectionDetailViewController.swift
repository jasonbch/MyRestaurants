//
//  CollectionDetailViewController.swift
//  foodr
//
//  Created by Phong Bach on 4/15/21.
//

import UIKit
import CoreData

class CollectionDetailViewController: UIViewController, UITextFieldDelegate {
    var tappedRestaurant: NSManagedObject?
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantRatingLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var restaurantCityLabel: UILabel!
    @IBOutlet weak var restaurantStateLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantTextView: UITextView!
    @IBOutlet weak var addNoteButton: UIButton!
    
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var drinkButton: UIButton!
    @IBOutlet weak var dessertButton: UIButton!
    
    var isFood: Bool = false
    var isDrink: Bool = false
    var isDessert: Bool = false
    
    var categories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        initializeView()
        
        if let myRestaurant = tappedRestaurant {
            restaurantNameLabel?.text = myRestaurant.value(forKey: "name") as? String
            restaurantAddressLabel?.text = myRestaurant.value(forKey: "address") as? String
            restaurantCityLabel?.text = myRestaurant.value(forKey: "city") as? String
            restaurantStateLabel?.text = myRestaurant.value(forKey: "state") as? String
            restaurantRatingLabel?.text = (myRestaurant.value(forKey: "rating") as? Float)!.description
            if let myNote = myRestaurant.value(forKey: "note") as? String {
                if (myNote == "") {
                    restaurantTextView?.text = "Add a note..."
                } else {
                    restaurantTextView?.text = myNote
                }
            }
            
            if let categories = myRestaurant.value(forKey: "category") as? [String] {
                if categories.contains("Food") {
                    isFood = true;
                    foodButton.layer.borderColor = UIColor.black.cgColor
                    foodButton.setTitleColor(UIColor.black, for: .normal)
                } else {
                    isFood = false;
                    foodButton.layer.borderColor = UIColor.systemGray4.cgColor
                    foodButton.setTitleColor(UIColor.systemGray4, for: .normal)
                }
                if categories.contains("Drink") {
                    isDrink = true;
                    drinkButton.layer.borderColor = UIColor.black.cgColor
                    drinkButton.setTitleColor(UIColor.black, for: .normal)
                } else {
                    isDrink = false;
                    drinkButton.layer.borderColor = UIColor.systemGray4.cgColor
                    drinkButton.setTitleColor(UIColor.systemGray4, for: .normal)
                }
                if categories.contains("Dessert") {
                    isDessert = true;
                    dessertButton.layer.borderColor = UIColor.black.cgColor
                    dessertButton.setTitleColor(UIColor.black, for: .normal)
                } else {
                    isDessert = false;
                    dessertButton.layer.borderColor = UIColor.systemGray4.cgColor
                    dessertButton.setTitleColor(UIColor.systemGray4, for: .normal)
                }
            }
            
            if let imageData = myRestaurant.value(forKey: "image") as? Data {
                let image = UIImage(data:imageData, scale:1.0)
                restaurantImageView?.image = image
            } else {
                restaurantImageView?.image = UIImage(named: "default-image.jpg")
            }
        }
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        saveTapped()
        performSegue(withIdentifier: "unwindFromCollectionDetail", sender: nil)

    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindFromCollectionDetail", sender: nil)
    }
    
    // Save the new quotation
    func saveTapped() {
        if let myRestaurant = tappedRestaurant {
            if isFood {
                categories.append("Food")
            }
            if isDrink {
                categories.append("Drink")
            }
            if isDessert {
                categories.append("Dessert")
            }
            
            // Set value
            myRestaurant.setValue(restaurantTextView.text, forKey: "Note")
            myRestaurant.setValue(categories, forKey: "category")
            appDelegate.saveContext()
        }
    }
    
    @IBAction func foodButtonTapped(_ sender: UIButton) {
        isFood = !isFood
        
        if isFood {
            foodButton.layer.borderColor = UIColor.black.cgColor
            foodButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            foodButton.layer.borderColor = UIColor.systemGray4.cgColor
            foodButton.setTitleColor(UIColor.systemGray4, for: .normal)
        }
    }
    
    @IBAction func drinkButtonTapped(_ sender: UIButton) {
        isDrink = !isDrink
        
        if isDrink {
            drinkButton.layer.borderColor = UIColor.black.cgColor
            drinkButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            drinkButton.layer.borderColor = UIColor.systemGray4.cgColor
            drinkButton.setTitleColor(UIColor.systemGray4, for: .normal)
        }
    }
    
    @IBAction func dessertButtonTapped(_ sender: UIButton) {
        isDessert = !isDessert
        
        if isDessert {
            dessertButton.layer.borderColor = UIColor.black.cgColor
            dessertButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            dessertButton.layer.borderColor = UIColor.systemGray4.cgColor
            dessertButton.setTitleColor(UIColor.systemGray4, for: .normal)
        }
    }
        
    func initializeView() {	
        restaurantImageView?.contentMode = .scaleAspectFill
        restaurantImageView?.layer.cornerRadius = 10
        restaurantImageView?.layer.masksToBounds = true
        
        restaurantTextView.layer.cornerRadius = 4
        restaurantTextView.layer.masksToBounds = true
        
        foodButton.backgroundColor = .clear
        foodButton.layer.cornerRadius = 5
        foodButton.layer.borderWidth = 1
        foodButton.layer.borderColor = UIColor.systemGray4.cgColor
        foodButton.setTitleColor(UIColor.systemGray4, for: .normal)
        
        drinkButton.backgroundColor = .clear
        drinkButton.layer.cornerRadius = 5
        drinkButton.layer.borderWidth = 1
        drinkButton.layer.borderColor = UIColor.systemGray4.cgColor
        drinkButton.setTitleColor(UIColor.systemGray4, for: .normal)
        
        dessertButton.backgroundColor = .clear
        dessertButton.layer.cornerRadius = 5
        dessertButton.layer.borderWidth = 1
        dessertButton.layer.borderColor = UIColor.systemGray4.cgColor
        dessertButton.setTitleColor(UIColor.systemGray4, for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Remove keyboard on return
        return false // Do default behavior
    }
}
