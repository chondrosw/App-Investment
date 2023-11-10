//
//  SearchTableViewCell.swift
//  App Investment
//
//  Created by Chondro Satrio Wibowo on 10/11/23.
//

import Foundation
import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var assetSymbolLabel: UILabel!
    @IBOutlet weak var assetTypeLabel: UILabel!
    
    func configure(with searchResult: SearchResult){
        assetNameLabel.text = searchResult.the2Name
        assetSymbolLabel.text = searchResult.the1Symbol
        assetTypeLabel.text = searchResult.the3Type.appending(" ").appending(searchResult.the8Currency)
    }
}
