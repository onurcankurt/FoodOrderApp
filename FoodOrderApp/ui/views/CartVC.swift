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
    var totalPrice: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(cartFoodsChanged), name: NSNotification.Name("CartFoodsChanged"), object: nil)
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        _ = viewModel.cartFoodRXList.subscribe(onNext: { cartList in
            self.cartFoods = cartList
            
            NotificationCenter.default.post(name: NSNotification.Name("CartFoodsChanged"), object: nil)
            
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
            }
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.uploadCartFoods(user_name: "kurt_1996")
        DispatchQueue.main.async {
            self.cartTableView.reloadData()
        }
    }
    
    @IBAction func confirmCartButton(_ sender: Any) {
        let title = "Confirm Order"
        let message = "Are you sure you want to confirm the orders?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { alert in
            let yesAlert = UIAlertController(title: "Confirmed", message: "Your order has been received.", preferredStyle: .actionSheet)
            let okButton = UIAlertAction(title: "OK", style: .default)
            yesAlert.addAction(okButton)
            self.present(yesAlert, animated: true)
        }
        alert.addAction(cancelAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true)
    }
}

extension CartVC: CartCellProtocol{
    func deleteFood(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete the order?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { alert in
            
            let food = self.cartFoods[indexPath.row]
            self.viewModel.deleteFromCart(food_id: Int(food.sepet_yemek_id!)!, user_name: "kurt_1996")
            NotificationCenter.default.post(name: NSNotification.Name("CartFoodsChanged"), object: nil)
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
            }
            
        }
        alert.addAction(cancelAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true)
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
//        cell.backgroundColor = .yaziRenk2
//        cell.cellBackgroundView.backgroundColor = .yaziRenk2
//        cell.layer.borderColor = UIColor.lightGray.cgColor
//        cell.layer.borderWidth = 1
        
        
        cell.cellBackgroundView.layer.borderColor = UIColor.lightGray.cgColor
        cell.cellBackgroundView.layer.borderWidth = 1
        cell.cellBackgroundView.layer.cornerRadius = 10.0
        
        return cell
    }
    
    @objc func cartFoodsChanged(){
        totalPrice = 0
        for food in cartFoods{
            totalPrice += Int(food.yemek_fiyat!)! * Int(food.yemek_siparis_adet!)!
        }
        totalPriceLabel.text = "₺ \(totalPrice)"
    }
}

