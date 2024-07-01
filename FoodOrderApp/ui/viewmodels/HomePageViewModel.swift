//
//  HomePageViewModel.swift
//  FoodOrderApp
//
//  Created by onur on 18.06.2024.
//

import Foundation
import RxSwift
import UIKit

class HomePageViewModel {
    var frepo = FoodsDaoRepository()
    var foodRXList = BehaviorSubject(value: [Food]())
    
    init() {
        foodRXList = frepo.foodRXList
        uploadFoods()
    }
    
    func uploadFoods(){
        frepo.uploadFoods()
    }
    
    func addToFavorites(food_id: String, food_name: String){
        frepo.addToFavorites(food_id: food_id, food_name: food_name)
    }
    
    func deleteFromFavorites(id: String){
        frepo.deleteFromFavorites(id: id)
    }
    
    func addFoodToCart(food_name: String, food_image: String, food_price: Int, food_count: Int, user_name: String, viewcontroller: UIViewController){
        frepo.addFoodToCart(food_name: food_name, food_image: food_image, food_price: food_price, food_count: food_count, user_name: user_name, viewcontroller: viewcontroller)
    }
    
    func uploadSearchingFoods(searchText: String){
        frepo.uploadSearchingFoods(searchText: searchText)
    }
}
