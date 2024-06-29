//
//  FoodsResponse.swift
//  FoodOrderApp
//
//  Created by onur on 18.06.2024.
//

import Foundation

class FoodsResponse: Codable {
    var yemekler: [Food]?
    var success: Int?
}
