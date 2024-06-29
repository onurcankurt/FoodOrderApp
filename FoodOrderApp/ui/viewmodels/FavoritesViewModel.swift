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
}
