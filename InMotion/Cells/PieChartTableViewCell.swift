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
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pieChartView.delegate = self
        
        // pie chart formatting and options
        
        pieChartView.drawHoleEnabled = false
        
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
        let set = PieChartDataSet(entries:entries)
        set.colors = ChartColorTemplates.joyful()
        let data = PieChartData(dataSet: set)
        pieChartView.data = data
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PieChartTableViewCell", bundle: nil)
    }
    
}
