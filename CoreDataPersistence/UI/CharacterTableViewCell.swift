//
//  CharacterTableViewCell.swift
//  CoreDataPersistence
//
//  Created by Tunde on 06/06/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import UIKit
import Kingfisher

class CharacterTableViewCell: UITableViewCell {

    static let cellId = "CharacterTableViewCell"
    
    @IBOutlet weak var iconImgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    func configure(with character: Character) {
        
        nameLbl.text = character.name
        iconImgVw.kf.indicatorType = .activity
        iconImgVw.kf.setImage(with: URL(string: character.image ?? ""))
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLbl.text = ""
        iconImgVw.image = nil
    }
}
