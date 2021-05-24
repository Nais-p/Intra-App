//
//  InfosTableViewCell.swift
//  App-Intra
//
//  Created by Anaïs Puig on 12/04/2021.
//

import UIKit

// Fichier permettant de faire les liens pour afficher les information dans les tables View (fichier InfosControllers)
class InfosTableViewCell: UITableViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var mess: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

