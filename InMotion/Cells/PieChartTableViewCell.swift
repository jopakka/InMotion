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
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pieChartView.delegate = self
        
        var entries = [ChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        let set = PieChartDataSet(entries:entries)
        set.colors = ChartColorTemplates.joyful()
        let data = PieChartData(dataSet: set)
        pieChartView.data = data
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    public func configure(with image: UIImage){
//        pieChartImage.image = image
//    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PieChartTableViewCell", bundle: nil)
    }
    
}
