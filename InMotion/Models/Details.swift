//
//  Details.swift
//  InMotion
//
//  Created by iosdev on 3.5.2021.
//

import Foundation

// Struct to hold data values for processed journeys
struct Details {
    var distanceTravelled = Double()
    var timeTravelledInSeconds = Double()
    var co2Emissions = Double()
    var modeTransports = [Int: [String : Double]]()
    var popularTransport = String()
    var pieChartData = [String: Double]()
    var chartData = [String: Double]()
    var title: String?
    
    // initiator to set the variables of the struct
    init(dailyInfo: [Dictionary<String, Double>], transports: [Int: [String : Double]]){
        
        // taking an array of dictionaries and returning a new array with values matching
        // this new array is then reduced into a single "total" value
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
        co2Emissions = co2Emissions / 1000
        
        // passed data is processed into a easy to read format
        popularTransport = transportMode(value: popularTransport)
        modeTransports = transports
        
        // piechart data is generated
        createPieData()
        
    }
    
    // funcion that processes transport data into usable pie chart data
    mutating func createPieData(){
        var const = 0.0
        
        for x in modeTransports {
            for y in x.value {
                if const < y.value {
                    const = y.value
                    popularTransport = transportMode(value: y.key)
                    
                }
                if let entry = pieChartData[y.key] {
                    pieChartData[y.key] = entry + y.value
                }else {
                    pieChartData[y.key] = y.value
                }
            }
            
        }
        
        pieChartData.forEach{
            let value = $0.value
            let newValue = Double(value) / timeTravelledInSeconds * 100
            chartData[transportMode(value: $0.key)] = newValue
        }
        if pieChartData.isEmpty {
            chartData[NSLocalizedString("no_data", comment: "")] = 100
            return
        }
        
        let total = chartData.compactMap( {Double($0.value)}).reduce(0.0, +)
        
        chartData[NSLocalizedString("stationary", comment: "")] = Double(100 - total)
        
    }
    
}

// Simpifies the Moprim return value into easy to read string and localisation
func transportMode(value: String) -> String {
    
    switch value {
    case "stationary":
        return NSLocalizedString("stationary", comment: "")
    case "non-motorized":
        return NSLocalizedString("non-motorized", comment: "")
    case "non-motorized/pedestrian":
        return NSLocalizedString("pedestrian", comment: "")
    case "non-motorized/pedestrian/walk":
        return NSLocalizedString("walk", comment: "")
    case "non-motorized/bicycle":
        return NSLocalizedString("bicycle", comment: "")
    case "non-motorized/pedestrian/run":
        return NSLocalizedString("run", comment: "")
    case "motorized":
        return NSLocalizedString("motorized", comment: "")
    case "motorized/road/":
        return NSLocalizedString("road", comment: "")
    case "motorized/road/car":
        return NSLocalizedString("car", comment: "")
    case "motorized/road/bus":
        return NSLocalizedString("bus", comment: "")
    case "motorized/rail":
        return NSLocalizedString("rail", comment: "")
    case "motorized/rail/tram":
        return NSLocalizedString("tram", comment: "")
    case "motorized/rail/train":
        return NSLocalizedString("train", comment: "")
    case "motorized/rail/metro":
        return NSLocalizedString("metro", comment: "")
    case "motorized/air/plane":
        return NSLocalizedString("plane", comment: "")
    default:
        return NSLocalizedString("unknown", comment: "")
    }
}

