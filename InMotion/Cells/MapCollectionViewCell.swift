//
//  MapCollectionViewCell.swift
//  InMotion
//
//  Created by iosdev on 29.4.2021.
//

import UIKit
import MapKit

class MapCollectionViewCell: UICollectionViewCell, MKMapViewDelegate {

    static var identifier = "MapCollectionViewCell"
    var routeString: String?
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(with route: String){
        routeString = route
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MapCollectionViewCell", bundle: nil)
    }
}
