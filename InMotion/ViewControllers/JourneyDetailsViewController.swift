//
//  JourneyDetailsViewController.swift
//  InMotion
//
//  Created by iosdev on 17.4.2021.
//

import UIKit

class JourneyDetailsViewController: UIViewController{
    
    
    
    var index: Int?
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.setCollectionViewLayout(JourneyDetailsViewController.createLayout(), animated: true)
    
        collectionView.register(JourneyDetailsCollectionViewCell.nib(), forCellWithReuseIdentifier: JourneyDetailsCollectionViewCell.identifier)
        collectionView.register(ImagePostCollectionViewCell.nib(), forCellWithReuseIdentifier: ImagePostCollectionViewCell.identifier)
        collectionView.register(MapCollectionViewCell.nib(), forCellWithReuseIdentifier: MapCollectionViewCell.identifier)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    
    static func createSingleCellLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/3))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitem: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    static func createImageLayout() -> NSCollectionLayoutSection{
        //item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1))
            )
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let verticalStackItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.5)
            )
    )
        verticalStackItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2, leading: 2, bottom: 2, trailing: 2)
        
        
        //group
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            ),
            subitem: verticalStackItem,
            count: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(3/5)),
            subitems: [
            item,
            verticalGroup
            ]
        )
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            if sectionIndex == 0 || sectionIndex == 1 {
                return self.createSingleCellLayout()
            }else{
                return self.createImageLayout()
            }
        }
        return layout
    }
    

    
}

extension JourneyDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            print("item was pressed!")
        }
        
    }
   
    
}

extension JourneyDetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }else {
            return 30
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCollectionViewCell.identifier, for: indexPath) as! MapCollectionViewCell
            
            cell.configure(with: "route goes here")
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneyDetailsCollectionViewCell.identifier, for: indexPath) as! JourneyDetailsCollectionViewCell
            
            cell.configure(distanceTravelled: "10km", timeTravelled: "30mins", emissions: "300g", popularTransport: "Bus", averageSpeed: "60km/h")
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePostCollectionViewCell.identifier, for: indexPath) as! ImagePostCollectionViewCell
            
            let images: [UIImage] = [
            UIImage(named: "image1"),
                UIImage(named: "image2"),
                UIImage(named: "image3"),
                UIImage(named: "image4"),
                UIImage(named: "image5"),
                UIImage(named: "image6"),
                UIImage(named: "image7"),
                UIImage(named: "image8"),
                UIImage(named: "image9"),
                UIImage(named: "image10")
            ].compactMap({$0})
            cell.imageView.image = images.randomElement()
            return cell
        }
        
    }
}

