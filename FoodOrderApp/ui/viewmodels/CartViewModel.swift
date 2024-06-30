//
//  CartViewModel.swift
//  FoodOrderApp
//
//  Created by onur on 30.06.2024.
//

import Foundation
import RxSwift

class CartViewModel {
    var frepo = FoodsDaoRepository()
    var cartFoodRXList = BehaviorSubject(value: [CartFood]())
    
    init() {
        cartFoodRXList = frepo.cartFoodRXList
        uploadCartFoods(user_name: "kurt_1996")
    }
    
    
    func uploadCartFoods(user_name: String){
        frepo.uploadCartFoods(user_name: user_name)
    }
    
    func deleteFromCart(food_id: Int, user_name: String){
        frepo.deleteFromCart(food_id: food_id, user_name: user_name)
    }
}
