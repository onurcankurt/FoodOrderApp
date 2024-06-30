//
//  FoodDetailVC.swift
//  FoodOrderApp
//
//  Created by onur on 27.06.2024.
//

import UIKit

class FoodDetailVC: UIViewController {
    
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var foodImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var foodCount: Int = 0
    
    var totalPrice: Int = 0
    
    var detailsFood: Food?
    
    var viewModel = FoodDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let food = detailsFood {
            if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(food.yemek_resim_adi!)"){
                DispatchQueue.main.async {
                    self.foodImageView.kf.setImage(with: url)
                }
            }
            
            priceLabel.text = "₺ \(food.yemek_fiyat!)"
            nameLabel.text = "\(food.yemek_adi!)"
            numberLabel.text = "\(foodCount)"
            totalPriceLabel.text = "₺ \(totalPrice)"
            
            if food.yemek_fav == true{
                self.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                self.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
    @IBAction func favButtonClicked(_ sender: Any) {
        if let food = detailsFood {
            if food.yemek_fav == false {
                food.yemek_fav?.toggle()
                viewModel.addToFavorites(food_id: food.yemek_id!, food_name: food.yemek_adi!)
                self.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                food.yemek_fav?.toggle()
                viewModel.deleteFromFavorites(id: food.id!)
                self.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
            print("\(food.yemek_fav!)-\(food.yemek_id!)")
        }
    }
    
    @IBAction func decreaseButton(_ sender: Any) {
        if foodCount > 0 {
            foodCount -= 1
            numberLabel.text = "\(foodCount)"
            if let food = detailsFood{
                totalPriceLabel.text = "₺ \(foodCount * Int(food.yemek_fiyat!)!)"
            }
        }
    }
    
    @IBAction func increaseButton(_ sender: Any) {
        if foodCount < 999 {
            foodCount += 1
            numberLabel.text = "\(foodCount)"
            if let food = detailsFood{
                totalPriceLabel.text = "₺ \(foodCount * Int(food.yemek_fiyat!)!)"
            }
        }
    }
    
    @IBAction func addToCartButton(_ sender: Any) {
        if let food = detailsFood{
            viewModel.addFoodToCart(food_name: food.yemek_adi!, food_image: food.yemek_resim_adi!, food_price: Int(food.yemek_fiyat!)!, food_count: self.foodCount, user_name: "kurt_1996")
        }
        
    }
}
