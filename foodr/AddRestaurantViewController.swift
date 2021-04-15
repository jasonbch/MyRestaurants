//
//  addRestaurantViewController.swift
//  foodr
//
//  Created by Phong Bach on 4/6/21.
//

import UIKit

class AddRestaurantViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var AddRestaurantButton: UIButton!
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var AddressTextField: UITextField!
    
    var newName: String?
    var newAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AddRestaurantButton.layer.cornerRadius = 4
        
        TitleTextField.delegate = self
        AddressTextField.delegate = self
        
    }
    
    // Save the new quotation
    func AddTapped() {
        self.view.endEditing(true)
        
        if (TitleTextField.hasText) {
            if (AddressTextField.hasText) {
                newName = TitleTextField.text!
                newAddress = AddressTextField.text!
            } else {
                newName = TitleTextField.text!
            }
            
            // Clear the fields
            TitleTextField.text = ""
            AddressTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Remove keyboard on return
        return false // Do default behavior
    }
    
    // Segue when cancel is tapped
    @IBAction func unwindToMainViewCancel (_ sender: UIButton) {
        performSegue(withIdentifier: "unwindFromAddRestaurantView", sender: nil)
    }
    
    @IBAction func unwindeToMainViewAdd(_ sender: UIButton) {
        AddTapped()
        performSegue(withIdentifier: "unwindFromAddRestaurantView", sender: nil)
    }
}
