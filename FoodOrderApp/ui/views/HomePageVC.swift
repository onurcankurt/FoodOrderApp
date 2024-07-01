//
//  ViewController.swift
//  FoodOrderApp
//
//  Created by onur on 15.06.2024.
//

import UIKit
import Kingfisher

class HomePageVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var foodsCollectionView: UICollectionView!
    
    var foodList = [Food]()
    var viewModel = HomePageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteStatusChanged), name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
        
        searchBar.delegate = self
        foodsCollectionView.delegate = self
        foodsCollectionView.dataSource = self
        
        _ = viewModel.foodRXList.subscribe(onNext: { foods in
            self.foodList = foods
            DispatchQueue.main.async {
                self.foodsCollectionView.reloadData()
            }
        })
        
        let design = UICollectionViewFlowLayout()

        design.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        design.minimumLineSpacing = 10
        design.minimumInteritemSpacing = 10
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 30) / 2
        
        design.itemSize = CGSize(width: itemWidth-2, height: itemWidth * 1.55)
        foodsCollectionView.collectionViewLayout = design
    }
    
    @objc func favoriteStatusChanged() {
        // Verileri yeniden yükle
        viewModel.uploadFoods()
        foodsCollectionView.reloadData()
    }
}

extension HomePageVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search: \(searchText)")
        if searchText != ""{
            viewModel.uploadSearchingFoods(searchText: searchText)
        } else {
            viewModel.uploadFoods()
        }
    }
}

extension HomePageVC: FoodCellProtocol {
    func addToCart(indexPath: IndexPath) {
        let food = foodList[indexPath.row]
        viewModel.addFoodToCart(food_name: food.yemek_adi!, food_image: food.yemek_resim_adi!, food_price: Int(food.yemek_fiyat!)!, food_count: 1, user_name: "kurt_1996", viewcontroller: self)
    }
    
    func toggleFavorite(indexPath: IndexPath) {
        let food = foodList[indexPath.row]
        
        if food.yemek_fav == false {
            food.yemek_fav?.toggle()
            viewModel.addToFavorites(food_id: food.yemek_id!, food_name: food.yemek_adi!)
        } else {
            food.yemek_fav?.toggle()
            viewModel.deleteFromFavorites(id: food.id!)
        }
        NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
        print("\(food.yemek_fav!)-\(food.yemek_id!)")
    }
}

extension HomePageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let food = foodList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCollectionCell", for: indexPath) as! FoodCollectionCell
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(food.yemek_resim_adi!)"){
            DispatchQueue.main.async {
                cell.foodImageView.kf.setImage(with: url)
            }
        }
        
        cell.foodNameLabel.text = "\(food.yemek_adi!)"
        cell.foodPriceLabel.text = "₺ \(food.yemek_fiyat!)"
        
        cell.indexPath = indexPath
        cell.foodCellProtocol = self
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        DispatchQueue.main.async {
            if food.yemek_fav == true{
                cell.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                cell.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let food = foodList[indexPath.row]
        performSegue(withIdentifier: "toFoodDetail", sender: food)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFoodDetail"{
            if let senderFood = sender as? Food{
                let destinationVC = segue.destination as! FoodDetailVC
                destinationVC.detailsFood = senderFood
            }
        }
    }
}

