//
//  FoodCollectionCell.swift
//  FoodOrderApp
//
//  Created by onur on 18.06.2024.
//

import UIKit

protocol FoodCellProtocol {
    func addToCart(indexPath: IndexPath)
    func toggleFavorite(indexPath: IndexPath)
}

class FoodCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var foodCellProtocol: FoodCellProtocol?
    var indexPath: IndexPath?
    
    
    @IBAction func foodFavButton(_ sender: Any) {
        foodCellProtocol?.toggleFavorite(indexPath: indexPath!)
    }
    
    @IBAction func addToCartButton(_ sender: Any) {
        foodCellProtocol?.addToCart(indexPath: indexPath!)
    }
}
