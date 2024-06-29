//
//  Food.swift
//  FoodOrderApp
//
//  Created by onur on 18.06.2024.
//

import Foundation

class Food: Codable {
    var id: String?
    var yemek_id: String?
    var yemek_adi: String?
    var yemek_resim_adi: String?
    var yemek_fiyat: String?
    var yemek_fav: Bool?
    
    init() {
    }
    
    init(id: String, yemek_id: String, yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: String, yemek_fav: Bool) {
        self.id = id
        self.yemek_id = yemek_id
        self.yemek_adi = yemek_adi
        self.yemek_resim_adi = yemek_resim_adi
        self.yemek_fiyat = yemek_fiyat
        self.yemek_fav = false
    }
}
