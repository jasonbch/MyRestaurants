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
    @IBOutlet weak var CityTextField: UITextField!
    @IBOutlet weak var StateTextField: UITextField!
    @IBOutlet weak var RatingTextField: UITextField!
    @IBOutlet weak var NoteTextView: UITextView!
    
    var newName: String?
    var newAddress: String?
    var newCity: String?
    var newState: String?
    var newRating: Float?
    var newNote: String?
    
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
            newName = TitleTextField.text!
            
            if (AddressTextField.hasText) {
                newAddress = AddressTextField.text!
            } else {
                newAddress = ""
            }
            if (CityTextField.hasText) {
                newCity = CityTextField.text!
            } else {
                newCity = ""
            }
            if (StateTextField.hasText) {
                newState = StateTextField.text!
            } else {
                newState = ""
            }
            if (RatingTextField.hasText) {
                newRating = Float(RatingTextField.text!)
            } else {
                newRating = 0
            }
            if (NoteTextView.hasText) {
                newNote = NoteTextView.text!
            } else {
                newNote = ""
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
