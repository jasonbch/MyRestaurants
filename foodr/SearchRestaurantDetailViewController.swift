//
//  SearchRestaurantDetailViewController.swift
//  foodr
//
//  Created by Phong Bach on 4/13/21.
//

import UIKit
import CoreData

class SearchRestaurantDetailViewController: UIViewController {

    var tappedRestaurant: TempRestaurant?
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var restaurantCityLabel: UILabel!
    @IBOutlet weak var restaurantStateLabel: UILabel!
    @IBOutlet weak var restaurantRatingLabel: UILabel!
    @IBOutlet weak var restaurantNoteLabel: UILabel!
    @IBOutlet weak var addToCollectionButton: UIButton!
    @IBOutlet weak var restaurantNoteTextField: UITextView!
    
    @IBOutlet weak var dessertButton: UIButton!
    @IBOutlet weak var drinkButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    
    var isFood: Bool = false
    var isDrink: Bool = false
    var isDessert: Bool = false
    
    var category: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        if let myRestaurant = tappedRestaurant {
            restaurantNameLabel?.text = myRestaurant.name
            restaurantAddressLabel?.text = myRestaurant.address
            restaurantCityLabel?.text = myRestaurant.city
            restaurantStateLabel?.text = myRestaurant.state
            restaurantRatingLabel?.text = myRestaurant.rating.description
            restaurantNoteLabel?.text = "Note: "
            
            if let imageData = myRestaurant.image {
                let image = UIImage(data:imageData, scale:1.0)
                restaurantImageView?.image = image
            } else {
                restaurantImageView?.image = UIImage(named: "default-image.jpg")
            }
        }
        
        initializeView()
    }
    
    func initializeView() {
        restaurantImageView?.contentMode = .scaleAspectFill
        restaurantImageView?.layer.cornerRadius = 10
        restaurantImageView?.layer.masksToBounds = true
        
        addToCollectionButton.layer.cornerRadius = 4
        addToCollectionButton.layer.masksToBounds = true
        
        foodButton.backgroundColor = .clear
        foodButton.layer.cornerRadius = 5
        foodButton.layer.borderWidth = 1
        foodButton.layer.borderColor = UIColor.systemGray5.cgColor
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
    
    @IBAction func addToCollectionButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add to Collection?",
                                      message: nil, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Yes", style: .default,
                                       handler: { [self] (action) in
            addRestaurant()
        })
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel,
        handler: { (action) in
        })
        
        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addRestaurant() {
        if let myRestaurant = tappedRestaurant {
            let name = myRestaurant.name
            let rating = myRestaurant.rating
            let image = myRestaurant.image
            let address = myRestaurant.address
            let city = myRestaurant.city
            let state = myRestaurant.state
            let id = myRestaurant.id
            let myNote: String
            if let note = restaurantNoteTextField.text {
                myNote = note
            } else {
                myNote = ""
            }
            
            if isFood {
                category.append("Food")
            }
            if isDrink {
                category.append("Drink")
            }
            if isDessert {
                category.append("Dessert")
            }
            
            insertRestaurant(name: name, address: address, city: city, state: state, rating: rating, image: image, id: id, note: myNote, category: category)
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
    
    func insertRestaurant(name: String?,
                          address: String?,
                          city: String?,
                          state: String?,
                          rating: Float?,
                          image: Data?,
                          id: String?,
                          note: String?,
                          category: [String]?) {
        let restaurant = NSEntityDescription.insertNewObject(forEntityName:
        "Restaurant", into: self.managedObjectContext)
        restaurant.setValue(name, forKey: "name")
        restaurant.setValue(address, forKey: "address")
        restaurant.setValue(rating, forKey: "rating")
        restaurant.setValue(image, forKey: "image")
        restaurant.setValue(id, forKey: "id")
        restaurant.setValue(city, forKey: "city")
        restaurant.setValue(state, forKey: "state")
        restaurant.setValue(note, forKey: "note")
        restaurant.setValue(category, forKey: "category")
        appDelegate.saveContext() // In AppDelegate.swift
    }
}
