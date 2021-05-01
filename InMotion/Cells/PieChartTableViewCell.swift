//
//  pieChartTableViewCell.swift
//  InMotion
//
//  Created by iosdev on 29.4.2021.
//

import Charts
import UIKit


class PieChartTableViewCell: UITableViewCell, ChartViewDelegate {

    static var identifier = "PieChartTableViewCell"
    var entries = [ChartDataEntry]()
    
    @IBOutlet weak var pieChart: PieChartView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pieChart.delegate = self
        

        
    
    }
    
    public func configure(pieChartDataArray data: [String: Int]){
        
        for x in data {
            entries.append(PieChartDataEntry(value: Double(x.value), label: x.key))
        }
        let dataSet = PieChartDataSet(entries:entries)
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        
        configureChart(pieChart)
        formatLegend(pieChart.legend)
        formatDescription(pieChart.chartDescription)
        formatDataSet(dataSet)
        formatData(data)
        
        
        pieChart.notifyDataSetChanged()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PieChartTableViewCell", bundle: nil)
    }
    
    
    func configureChart(_ pieChart: PieChartView){
        //pieChart.drawHoleEnabled = false
        pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        pieChart.drawEntryLabelsEnabled = false
    }
    
    func formatDescription(_ description: Description){
        description.text = "Daily Travel Breakdown"
        description.font = UIFont.systemFont(ofSize: 15)
    }
    
    func formatCenter(_ pieChart: PieChartView){
        pieChart.centerTextRadiusPercent = 0.95

    }
    
    func formatLegend(_ legend: Legend){
        legend.font = UIFont.systemFont(ofSize: 13)
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.xEntrySpace = 7
        legend.yEntrySpace = 0
        legend.yOffset = 0

    }
    
    func formatDataSet(_ dataSet: ChartDataSet){
        dataSet.colors = ChartColorTemplates.vordiplom()
        dataSet.label = ""
        
    }
    
    func formatData(_ data: PieChartData){
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 15, weight: .regular))
        data.setValueTextColor(.black)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let text = entry.value(forKey: "label") as! String
        let font = UIFont.systemFont(ofSize: 18)
        let myAttribute = [ NSAttributedString.Key.font: font]
        let myAttrString = NSAttributedString(string: text, attributes: myAttribute)
        pieChart.centerAttributedText = myAttrString
    }
}
