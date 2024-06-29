//
//  FavoritesVC.swift
//  FoodOrderApp
//
//  Created by onur on 20.06.2024.
//

import UIKit
import Kingfisher

class FavoritesVC: UIViewController {
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    var favoritesList = [Food]()
    var viewModel = FavoritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
        
        _ = viewModel.favoriteFoodsRXList.subscribe(onNext: { foodList in
            self.favoritesList = foodList
            self.favoritesCollectionView.reloadData()
        })
        
        let design = UICollectionViewFlowLayout()

        design.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        design.minimumLineSpacing = 10
        design.minimumInteritemSpacing = 10
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 30) / 2
        
        design.itemSize = CGSize(width: itemWidth-2, height: itemWidth * 1.55)
        
        favoritesCollectionView.collectionViewLayout = design

    }
}

extension FavoritesVC: FoodCellProtocol{
    func addToCart(indexPath: IndexPath) {
        print("addtocart")
    }
    
    func toggleFavorite(indexPath: IndexPath) {
        let food = favoritesList[indexPath.row]
        viewModel.deleteFromFavorites(id: food.id!)
        
    }
}

extension FavoritesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoritesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let food = favoritesList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritesCollectionCell", for: indexPath) as! FavoritesCollectionCell
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(food.yemek_resim_adi!)"){
            DispatchQueue.main.async {
                cell.favoritesImageView.kf.setImage(with: url)
            }
        }
        
        cell.nameLabel.text = "\(food.yemek_adi!)"
        cell.priceLabel.text = "₺ \(food.yemek_fiyat!)"
        
        cell.indexPath = indexPath
        cell.favoritesCellProtocol = self
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
//        if food.yemek_fav == true{
//            cell.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        } else {
//            cell.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        }
        
        return cell
    }
    
}
