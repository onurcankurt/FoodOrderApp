//
//  FoodDetailViewModel.swift
//  FoodOrderApp
//
//  Created by onur on 29.06.2024.
//

import Foundation

class FoodDetailViewModel {
    var frepo = FoodsDaoRepository()
    
    func addToFavorites(food_id: String, food_name: String){
        frepo.addToFavorites(food_id: food_id, food_name: food_name)
    }
    
    func deleteFromFavorites(id: String){
        frepo.deleteFromFavorites(id: id)
    }
}
