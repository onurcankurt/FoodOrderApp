//
//  FavoritesViewModel.swift
//  FoodOrderApp
//
//  Created by onur on 23.06.2024.
//

import Foundation
import RxSwift

class FavoritesViewModel {
    var frepo = FoodsDaoRepository()
    var favoriteFoodsRXList = BehaviorSubject(value: [Food]())
    
    init() {
        favoriteFoodsRXList = frepo.favoriteFoodsRXList
        uploadFavoriteFoods()
    }
    
    func uploadFavoriteFoods(){
        frepo.uploadFavoriteFoods()
    }
    
    func deleteFromFavorites(id: String){
        frepo.deleteFromFavorites(id: id)
    }
    
    func addFoodToCart(food_name: String, food_image: String, food_price: Int, food_count: Int, user_name: String){
        frepo.addFoodToCart(food_name: food_name, food_image: food_image, food_price: food_price, food_count: food_count, user_name: user_name)
    }
}
