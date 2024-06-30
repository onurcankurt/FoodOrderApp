//
//  CartTableCell.swift
//  FoodOrderApp
//
//  Created by onur on 29.06.2024.
//

import UIKit

protocol CartCellProtocol {
    func deleteFood(indexPath: IndexPath)
}

class CartTableCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var foodCountLabel: UILabel!
    
    @IBOutlet weak var foodTotalPriceLabel: UILabel!
    
    var indexPath: IndexPath?
    var cartCellProtocol: CartCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteFromCartButton(_ sender: Any) {
        cartCellProtocol?.deleteFood(indexPath: indexPath!)
    }
}
