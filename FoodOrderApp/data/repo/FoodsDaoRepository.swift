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
    
    var cartFoodRXList = BehaviorSubject(value: [CartFood]())
    
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
    
    func addFoodToCart(food_name: String, food_image: String, food_price: Int, food_count: Int, user_name: String){
        let params: Parameters = ["yemek_adi": food_name,
                                  "yemek_resim_adi": food_image,
                                  "yemek_fiyat": food_price,
                                  "yemek_siparis_adet": food_count,
                                  "kullanici_adi": user_name
        ]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let jsonResponse = try JSONDecoder().decode(CartCRUDResponse.self, from: data)
                    print(jsonResponse.message!)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func uploadCartFoods(user_name: String){
        let params: Parameters = ["kullanici_adi": user_name]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: params).response { response in
            if let data = response.data{
                do {
                    let jsonResponse = try JSONDecoder().decode(CartFoodsResponse.self, from: data)
                    print("\(jsonResponse.success!)")
                    if let list = jsonResponse.sepet_yemekler{
                        self.cartFoodRXList.onNext(list)
                    }
                } catch {
                    self.cartFoodRXList.onNext([CartFood]()) //son elemanı silerken hata verdiği için
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteFromCart(food_id: Int, user_name: String){
        let params : Parameters = ["sepet_yemek_id": food_id, "kullanici_adi": user_name]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do{
                    let jsonResponse = try JSONDecoder().decode(CartCRUDResponse.self, from: data)
                    self.uploadCartFoods(user_name: "kurt_1996")
                    print("\(jsonResponse.message!)")
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
