//
//  CartFoodsResponse.swift
//  FoodOrderApp
//
//  Created by onur on 30.06.2024.
//

import Foundation

class CartFoodsResponse: Codable {
    var sepet_yemekler: [CartFood]?
    var success: Int?
}
