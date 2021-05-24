//
//  NoteTableViewCell.swift
//  App-Intra
//
//  Created by Jacques Liao on 13/04/2021.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var uv_name: UILabel!
    @IBOutlet weak var uv_long_name: UILabel!
    @IBOutlet weak var activity_name:
        UILabel!
    @IBOutlet weak var my_note: UILabel!
    @IBOutlet weak var moy_promo: UILabel!
    @IBOutlet weak var min_note: UILabel!
    @IBOutlet weak var max_note: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
