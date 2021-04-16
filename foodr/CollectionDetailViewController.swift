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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //TitleTextField.delegate = self
        //AddressTextField.delegate = self
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        if let myRestaurant = tappedRestaurant {
            restaurantNameLabel?.text = myRestaurant.value(forKey: "name") as? String
            restaurantAddressLabel?.text = myRestaurant.value(forKey: "address") as? String
            restaurantCityLabel?.text = myRestaurant.value(forKey: "city") as? String
            restaurantStateLabel?.text = myRestaurant.value(forKey: "state") as? String
            restaurantRatingLabel?.text = (myRestaurant.value(forKey: "rating") as? Float)!.description
//            restaurantNoteLabel?.text = "Note: "
            
            if let imageData = myRestaurant.value(forKey: "image") as? Data {
                let image = UIImage(data:imageData, scale:1.0)
                restaurantImageView?.image = image
            } else {
                restaurantImageView?.image = UIImage(named: "default-image.jpg")
            }
        }
        
        initializeView()
    }
    
    // Save the new quotation
    func saveTapped() {
        self.view.endEditing(true)
        
//        if (TitleTextField.hasText) {
//            if (AddressTextField.hasText) {
//                newName = TitleTextField.text!
//                newAddress = AddressTextField.text!
//            } else {
//                newName = TitleTextField.text!
//            }
//
//            // Clear the fields
//            TitleTextField.text = ""
//            AddressTextField.text = ""
//        }
        
        
    }
    
    func initializeView() {
        restaurantImageView?.contentMode = .scaleAspectFill
        restaurantImageView?.layer.cornerRadius = 10
        restaurantImageView?.layer.masksToBounds = true
        
//        addToCollectionButton.layer.cornerRadius = 4
//        addToCollectionButton.layer.masksToBounds = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Remove keyboard on return
        return false // Do default behavior
    }
}
