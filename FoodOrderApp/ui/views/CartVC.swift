//
//  CartVC.swift
//  FoodOrderApp
//
//  Created by onur on 29.06.2024.
//

import UIKit
import Kingfisher

class CartVC: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var cartFoods = [CartFood]()
    var viewModel = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        _ = viewModel.cartFoodRXList.subscribe(onNext: { cartList in
            self.cartFoods = cartList
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
            }
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.uploadCartFoods(user_name: "kurt_1996")
        cartTableView.reloadData()
    }
    
    @IBAction func confirmCartButton(_ sender: Any) {
    }
}

extension CartVC: CartCellProtocol{
    func deleteFood(indexPath: IndexPath) {
        let food = cartFoods[indexPath.row]
        viewModel.deleteFromCart(food_id: Int(food.sepet_yemek_id!)!, user_name: "kurt_1996")
        self.cartTableView.reloadData()
    }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let food = cartFoods[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartTableCell", for: indexPath) as! CartTableCell
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(food.yemek_resim_adi!)"){
            DispatchQueue.main.async {
                cell.cellImageView.kf.setImage(with: url)
            }
        }
        
        cell.foodCountLabel.text = "Number: \(food.yemek_siparis_adet!)"
        cell.foodNameLabel.text = "\(food.yemek_adi!)"
        cell.foodPriceLabel.text = "Price: ₺ \(food.yemek_fiyat!)"
        cell.foodTotalPriceLabel.text = "₺ \(Int(food.yemek_siparis_adet!)! * Int(food.yemek_fiyat!)!)"
        
        cell.cartCellProtocol = self
        cell.indexPath = indexPath
        
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.cellBackgroundView.layer.cornerRadius = 10.0
        
        return cell
    }
}

