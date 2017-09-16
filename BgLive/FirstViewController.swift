//
//  FirstViewController.swift
//  BgLive
//
//  Created by Nabil K on 2017-09-16.
//  Copyright © 2017 Nabil. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, LineChartDelegate {

    @IBOutlet weak var lineChart: LineChart!
    var glucoseLineData: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        lineChart.colors[0] = UIColor(colorLiteralRed: 236.0/255.0, green: 27.0/255.0, blue: 82.0/255.0, alpha: 1.0)

        lineChart.y.axis.visible = false
        lineChart.y.axis.inset = 30
        lineChart.delegate = self
        
        buildLineChart()
        lineChart.animation.enabled = true
        
        
    }
    
    func buildLineChart(){
        
        
        let glucoseFiles = Helper.getGlucose()
        self.glucoseLineData = glucoseFiles.map{ CGFloat($0.rawValue) }
        
        lineChart.addLine(glucoseLineData)
        
    }


    
    
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
//        let dateIndex = Int(x)
    }
    
    
    
}

