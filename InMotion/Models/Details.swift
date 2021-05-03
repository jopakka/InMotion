//
//  Details.swift
//  InMotion
//
//  Created by iosdev on 3.5.2021.
//

import Foundation

struct Details {
    var distanceTravelled = Double()
    var timeTravelledInSeconds = Double()
    var co2Emissions = Double()
    var modeTransports = [String : Double]()
    var popularTransport = String()
    var pieChartData = [String: Int]()
    var title: String?
    
    init(dailyInfo: [Dictionary<String, Double>], transports: [String : Double]){
        distanceTravelled = dailyInfo.compactMap { dict in
            return dict["Distance Travelled"]
        }.reduce(0, {$0 + $1})
        timeTravelledInSeconds = dailyInfo.compactMap { dict in
            return dict["Time Spent Travelling"]
        }.reduce(0, {$0 + $1})
        co2Emissions = dailyInfo.compactMap { dict in
            return dict["Total CO2 Emmissions"]
        }.reduce(0, {$0 + $1})
        distanceTravelled = distanceTravelled / 1000
        popularTransport = transports.max{a, b in a.value < b.value }?.key ?? "no data"
        popularTransport = transportMode(value: popularTransport)
        modeTransports = transports
        createPieData()
    }
    
    
    mutating func createPieData(){
        for (key, value) in modeTransports {
            pieChartData[self.transportMode(value: key)] = Int(value/timeTravelledInSeconds * 100)
        }
        if pieChartData.isEmpty {
            pieChartData["No Data"] = 100
        }
    }
    
    func transportMode(value: String) -> String {
        
        switch value {
        case "non-motorized/pedestrian/walk":
            return "Walking"
        case "non-motorized/bicycle":
            return "Bicycle"
        case "non-motorized/pedestrian/run":
            return "Running"
        case "motorized/road/car":
            return "Car"
        case "motorized/road/bus":
            return "Bus"
        case "motorized/rail/tram":
            return "Tram"
        case "motorized/rail/train":
            return "Train"
        case "motorized/rail/metro":
            return "Metro"
        case "motorized/air/plane":
            return "Airplane"
        default:
            return value.capitalized
        }
    }
}
