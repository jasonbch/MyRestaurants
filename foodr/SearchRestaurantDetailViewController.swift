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
            restaurantRatingLabel?.text = "Rating: " + myRestaurant.rating.description
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
    }
    
    @IBAction func addToCollectionButtonTapped(_ sender: UIButton) {
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
            
            insertRestaurant(name: name, address: address, city: city, state: state, rating: rating, image: image, id: id, note: myNote)
        }
    }
    
    func insertRestaurant(name: String?,
                          address: String?,
                          city: String?,
                          state: String?,
                          rating: Float?,
                          image: Data?,
                          id: String?,
                          note: String?) {
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
        appDelegate.saveContext() // In AppDelegate.swift
    }
}
