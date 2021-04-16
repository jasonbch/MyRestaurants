//
//  NoteTableViewCell.swift
//  foodr
//
//  Created by Phong Bach on 4/15/21.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantCityLabel: UILabel!
    @IBOutlet weak var restaurantRatingLabel: UILabel!
    @IBOutlet weak var restaurantNoteTextField: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        restaurantNoteTextField.isEditable = false;
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
