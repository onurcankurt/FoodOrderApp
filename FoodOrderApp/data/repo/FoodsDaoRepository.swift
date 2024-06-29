//
//  FoodsDaoRepository.swift
//  FoodOrderApp
//
//  Created by onur on 18.06.2024.
//

import Foundation
import RxSwift
import Alamofire
import FirebaseFirestore

class FoodsDaoRepository {
    var foodRXList = BehaviorSubject(value: [Food]())
    var favoriteFoodsRXList = BehaviorSubject(value: [Food]())
    
    var collectionFavoriteFoods = Firestore.firestore().collection("FavoriteFoods")
    
    func addToFavorites(food_id: String, food_name: String){
        let newFavorite: [String: Any] = ["food_id": food_id, "food_name": food_name]
        collectionFavoriteFoods.document().setData(newFavorite)
    }
    
    func deleteFromFavorites(id: String){
        collectionFavoriteFoods.document(id).delete()
        NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
    }
    
    func uploadFavoriteFoods(){
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(FoodsResponse.self , from: data)
                    if let liste = cevap.yemekler {
                        self.collectionFavoriteFoods.addSnapshotListener { snapshot, error in
                            var foodList = [Food]()
                            if let documents = snapshot?.documents {
                                for document in documents {
                                    let data = document.data()
                                    let id = document.documentID
                                    let food_id = data["food_id"] as? String ?? ""
                                    
                                    for food in liste {
                                        if food.yemek_id == food_id{
                                            food.id = id
                                            foodList.append(food)
                                        }
                                    }
                                }
                            }
                            self.favoriteFoodsRXList.onNext(foodList)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func uploadFoods(){
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(FoodsResponse.self , from: data)
                    if let liste = cevap.yemekler {
                        
                        for food in liste {
                            food.yemek_fav = false
                        }
                        
                        self.collectionFavoriteFoods.addSnapshotListener { snapshot, error in

                            if let documents = snapshot?.documents {
                                for document in documents {
                                    let data = document.data()
                                    let id = document.documentID
                                    let food_id = data["food_id"] as? String ?? ""
                                    
                                    for food in liste {
                                        if food.yemek_id == food_id{
                                            food.id = id
                                            food.yemek_fav = true
                                        }
                                    }
                                }
                            }
                        }
                        
                        self.foodRXList.onNext(liste)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
