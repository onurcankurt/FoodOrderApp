//
//  FavoritesCollectionCell.swift
//  FoodOrderApp
//
//  Created by onur on 23.06.2024.
//

import UIKit

class FavoritesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var favoritesImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var favoritesCellProtocol: FoodCellProtocol?
    var indexPath: IndexPath?
    
    @IBAction func favButtonClicked(_ sender: UIButton) {
        favoritesCellProtocol?.toggleFavorite(indexPath: indexPath!)
    }
    
    @IBAction func addToCartButton(_ sender: UIButton) {
        favoritesCellProtocol?.addToCart(indexPath: indexPath!)
    }
    
}
