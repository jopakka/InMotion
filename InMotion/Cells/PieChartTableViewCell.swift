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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(pieChartDataArray data: [String: Int]){
        
        for x in data {
            print(x)
            entries.append(PieChartDataEntry(value: Double(x.value), label: x.key))
        }
        let dataSet = PieChartDataSet(entries:entries)
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        
        configureChart(pieChart)
        formatLegend(pieChart.legend)
        formatDescription(pieChart.chartDescription)
        formatDataSet(dataSet)
        
        
        pieChart.notifyDataSetChanged()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PieChartTableViewCell", bundle: nil)
    }
    
    
    func configureChart(_ pieChart: PieChartView){
        
        pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        pieChart.drawEntryLabelsEnabled = false
    }
    
    func formatDescription(_ description: Description){
        description.text = "Daily Breakdown of Travel Modes"
    }
    
    func formatCenter(_ pieChart: PieChartView){
        pieChart.centerTextRadiusPercent = 0.95
    }
    
    func formatLegend(_ legend: Legend){
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.xEntrySpace = 7
        legend.yEntrySpace = 0
        legend.yOffset = 0
    }
    
    func formatDataSet(_ dataSet: ChartDataSet){
        dataSet.colors = ChartColorTemplates.joyful()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let text = entry.value(forKey: "label") as! String
        pieChart.centerText = """
            \(text)
            """
    }
}
