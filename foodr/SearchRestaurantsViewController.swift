//
//  DetailTableViewController.swift
//  foodr
//
//  Created by Phong Bach on 4/6/21.
//

import UIKit
import CoreData

class SearchRestaurantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate  {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var apikey = "DlcWTI3TX1aQ1YVxDh4Xck60DUING0H78NWFRTUXixFvoVZ1x-peHCjzcNrVhV-VuISrxvXsH8Fek0k8-KSZVGIX1WxQo2zGSHgWdEYA_fftHU3TuttNPdCaXl2ZXHYx"
    
    var restaurants: [TempRestaurant] = []
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    var locationManager = CLLocationManager()
    var currentLatitude: Double?
    var currentLongitude: Double?
    
    var currentSearch: String? = nil
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        restaurants.removeAll()
        managedObjectContext.reset()
        searchButtonTappedHelper()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.separatorColor = UIColor.gray
    }
    
    func searchButtonTappedHelper() {
        if let latitude = currentLatitude {
            if let longitude = currentLongitude {
                fetchYelpBusinesses(term: searchTextField.text!, latitude: latitude, longitude: longitude)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Set up location
        initializeLocation()
        
        // Set up button
        searchButton.layer.masksToBounds = true
        searchButton.layer.cornerRadius = 4
        
        // Set up table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        // Set up core data
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // Fetch businesses
        checkLocation()
    }
    
    // MARK: - Yelp API
    fileprivate func fetchYelpBusinesses(term: String, latitude: Double, longitude: Double) {
        var url: URL
        if !term.isEmpty {
            url = URL(string: "https://api.yelp.com/v3/businesses/search?term=\(term)&latitude=\(latitude)&longitude=\(longitude)")!
        } else {
            url = URL(string: "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)")!
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                let restaurantArray = json["businesses"] as! [[String: Any]]
                
                for currentRestaurant in restaurantArray {
                    let name = currentRestaurant["name"] as? String
                    let rating = currentRestaurant["rating"] as? Float
                    let imageUrl = currentRestaurant["image_url"] as? String
                    let location = currentRestaurant["location"] as? [String: Any]
                    let address = location?["address1"] as? String
                    let city = location?["city"] as? String
                    let state = location?["state"] as? String
                    let id = currentRestaurant["id"] as? String
                    
                    let restaurant = TempRestaurant(name: name ?? "Default",
                                                    id: id ?? "Default",
                                                    address: address ?? "Default",
                                                    city: city ?? "Default",
                                                    state: state ?? "Default",
                                                    rating: rating ?? 0)
                    
                    restaurants.append(restaurant)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    loadRestaurantImage(imageUrl!, id!)
                }
            } catch {
                print("caught")
            }
        }.resume()
    }
    
    func loadRestaurantImage(_ urlString: String, _ searchID: String) {
        // URL comes from API response; definitely needs some safety checks
        if let urlStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: urlStr) {
                let dataTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
                    if let imageData = data {
                        let image = UIImage(data: imageData)?.pngData()
                        
                        let filteredRestaurant = self.restaurants.filter { restaurant in
                            return restaurant.id == searchID
                        }
                        
                        filteredRestaurant[0].image = image
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
                dataTask.resume()
            }
        }
    }

    // MARK: - Segue
    
    // Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "getRestaurantDetail") {
            let thirdVC = segue.destination as! SearchRestaurantDetailViewController
            let row = self.tableView?.indexPathForSelectedRow?.row ?? 0
            thirdVC.tappedRestaurant = restaurants[row]
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantTableViewCell
        
        // Configure the cell...
        let myRestaurant = restaurants[indexPath.row]
        
        cell.restaurantNameLabel?.text = myRestaurant.name
        cell.restaurantAddressLabel?.text = myRestaurant.address
        cell.restaurantCityLabel?.text = myRestaurant.city
        cell.restaurantStateLabel?.text = myRestaurant.state
        cell.restaurantRatingLabel?.text = "Rating: " + myRestaurant.rating.description
        
        if let imageData = myRestaurant.image {
            let image = UIImage(data:imageData,scale:1.0)
            cell.restaurantImageView?.image = image ?? UIImage(named: "default-image.jpg")
        } else {
            cell.restaurantImageView?.image = UIImage(named: "default-image.jpg")
        }
        
        cell.restaurantImageView?.contentMode = .scaleAspectFill
        cell.restaurantImageView?.layer.cornerRadius = 10
        cell.restaurantImageView?.layer.masksToBounds = true

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    // MARK: - Location
    
    func initializeLocation() { // called from start up method
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("location authorized")
        case .denied, .restricted:
            print("location not authorized")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("unknown location authorization")
        }
    }
    
    // Delegate method called whenever location authorization status changes
    func locationManager(_ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus) {
        if ((status == .authorizedAlways) || (status == .authorizedWhenInUse)) {
            print("location changed to authorized")
        } else {
            print("location changed to not authorized")
        self.stopLocation()
        }
    }
    
    func startLocation () {
        let status = locationManager.authorizationStatus
        if (status == .authorizedAlways) ||
            (status == .authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopLocation () {
        locationManager.stopUpdatingLocation()
    }
    
    // Delegate method called when location changes
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        var locationStr = "Location (lat,long): "
        if let latitude = location?.coordinate.latitude {
            currentLatitude = latitude
            locationStr += String(format: "%.6f", latitude)
        } else {locationStr += "?"}
        if let longitude = location?.coordinate.longitude {
            currentLongitude = longitude
            locationStr += String(format: ", %.6f", longitude)
        } else {locationStr += ", ?"}
        print(locationStr)
    }
    
    // Delegate method called if location unavailable (recommended)
    func locationManager(_ manager: CLLocationManager,
        didFailWithError error: Error) {
        print("locationManager error: \(error.localizedDescription)")
    }
    
    func checkLocation() {
        startLocation()
        
        let alert = UIAlertController(title: "Location Service Disabled",
        message: "Go to device settings to enables locations ervies for this app.", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default,
        handler: { (action) in
        // execute some code when this option is selected
            print("Okay!")
        })
        
        alert.addAction(okayAction)
        
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("location authorized")
        case .denied, .restricted:
            print("location not authorized")
            present(alert, animated: true, completion: nil)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("unknown location authorization")
        }
    }
}
