//
//  SearchRestaurantDetailViewController.swift
//  foodr
//
//  Created by Phong Bach on 4/13/21.
//

import UIKit
import CoreData

class SearchRestaurantDetailViewController: UIViewController {

    var tappedRestaurant: NSManagedObject?
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var addToCollectionButton: UIButton!
    
    @IBOutlet weak var addToCollectionButtonTapped: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        if let restaurant = tappedRestaurant {
            restaurantNameLabel?.text = restaurant.value(forKey: "name") as? String
            restaurantAddressLabel?.text = restaurant.value(forKey: "address") as? String
            
            if let imageData = restaurant.value(forKey: "image") as? Data {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
