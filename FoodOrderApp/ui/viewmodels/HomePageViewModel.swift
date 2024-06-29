//
//  HomePageViewModel.swift
//  FoodOrderApp
//
//  Created by onur on 18.06.2024.
//

import Foundation
import RxSwift

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
}
