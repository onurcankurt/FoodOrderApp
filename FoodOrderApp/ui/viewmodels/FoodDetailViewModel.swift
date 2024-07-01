//
//  FoodDetailViewModel.swift
//  FoodOrderApp
//
//  Created by onur on 29.06.2024.
//

import Foundation
import UIKit

class FoodDetailViewModel {
    var frepo = FoodsDaoRepository()
    
    func addToFavorites(food_id: String, food_name: String){
        frepo.addToFavorites(food_id: food_id, food_name: food_name)
    }
    
    func deleteFromFavorites(id: String){
        frepo.deleteFromFavorites(id: id)
    }
    
    func addFoodToCart(food_name: String, food_image: String, food_price: Int, food_count: Int, user_name: String, viewcontroller: UIViewController){
        frepo.addFoodToCart(food_name: food_name, food_image: food_image, food_price: food_price, food_count: food_count, user_name: user_name, viewcontroller: viewcontroller)
    }
}
