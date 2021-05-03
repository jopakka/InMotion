//
//  MapCollectionViewCell.swift
//  InMotion
//
//  Created by iosdev on 29.4.2021.
//

import UIKit
import MapKit
import Polyline

class MapCollectionViewCell: UICollectionViewCell, MKMapViewDelegate {

    static var identifier = "MapCollectionViewCell"
    var dictOfPolylines: [Int: String?] = [:]
    let pointIfNil = CLLocationCoordinate2D(latitude: 40.23497, longitude: -3.77074)
    let polylineIfNil = "kr_nJcngvC"
    let modeIfNil = "unknown"
    var mode:String? = "unknown"
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(with route: [Int: String?]){
        dictOfPolylines = route
        
        for line in dictOfPolylines {
            print("pollyline: ", line)
            
            let polyline = Polyline(encodedPolyline: line.value ?? self.polylineIfNil)
            let decodedCoordinates: [CLLocationCoordinate2D]? = polyline.coordinates
            DispatchQueue.main.async{
                self.createPath(decodedCoordinates : decodedCoordinates ?? [self.pointIfNil], mode: self.mode ?? self.modeIfNil )
            }
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MapCollectionViewCell", bundle: nil)
    }
    
    
    
    func createPath(decodedCoordinates : [CLLocationCoordinate2D], mode : String) {
        mapView.delegate = self
        
        
        
        let polylineTwo = MKPolyline(coordinates: decodedCoordinates , count: decodedCoordinates.count )
        
        //  MKPolylineRenderer(overlay: polylineTwo).lineWidth = 5
        // MKPolylineRenderer(overlay: polylineTwo).strokeColor = .systemRed
        
        let pointIfNil = CLLocationCoordinate2D(latitude: 40.23497, longitude: -3.77074)
        
        // set annotations for start and end points
        let sourceLocation = decodedCoordinates.first ?? pointIfNil
        let destinationLocation = decodedCoordinates.last ?? pointIfNil
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
        let sourceAnotation = MKPointAnnotation()
        sourceAnotation.title = "Start"
        //sourceAnotation.subtitle = ""
        if let location = sourcePlaceMark.location {
            sourceAnotation.coordinate = location.coordinate
        }
        
        let destinationAnotation = MKPointAnnotation()
        destinationAnotation.title = "Finnish"
        //destinationAnotation.subtitle = ""
        if let location = destinationPlaceMark.location {
            destinationAnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnotation, destinationAnotation], animated: true)
        
        // show segment´s route
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        
        let rect = polylineTwo.boundingMapRect
        self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        mapView.addOverlay(polylineTwo)
        print("PATH DRAWN SUCCESSFULLY")
    }
}
