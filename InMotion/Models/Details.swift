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
    var modeTransports = [Int: [String : Double]]()
    var popularTransport = String()
    var pieChartData = [String: Double]()
    var chartData = [String: Double]()
    var title: String?
    
    init(dailyInfo: [Dictionary<String, Double>], transports: [Int: [String : Double]]){
        
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
        
        popularTransport = transportMode(value: popularTransport)
        modeTransports = transports
        createPieData()
        
    }
    
    
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
        
        //print("timeInSeconds: ", timeTravelledInSeconds)
        pieChartData.forEach{
            let value = $0.value
            let newValue = Double(value) / timeTravelledInSeconds * 100
            chartData[transportMode(value: $0.key)] = newValue
        }
        if pieChartData.isEmpty {
            chartData["No Data"] = 100
            return
        }
        
        let total = chartData.compactMap( {Double($0.value)}).reduce(0.0, +)
        
        chartData["Stationary"] = Double(100 - total)
        
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

