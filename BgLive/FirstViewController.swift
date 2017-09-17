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
        lineChart.x.axis.inset = 40
        lineChart.delegate = self


        buildLineChart()
        lineChart.animation.enabled = true
        addAxisLabels()



        lineChart.highlightDataPoints(10)
    }

    override func viewDidAppear(_ animated: Bool) {
         var graphAnimator = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(FirstViewController.animateGraphPoints), userInfo: nil, repeats: true)
    }


    var x:Int = 0
    func animateGraphPoints(){

        lineChart.highlightDataPoints(x)
        if (x <= 21) {
           x = x + 1
        }
        else if x == 22 {
            x = 0
        }




    }
    func addAxisLabels() {
        let xAxisLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        xAxisLabel.center = CGPoint(x: 290, y: 660)
        xAxisLabel.text = "Hour"
        self.view.addSubview(xAxisLabel)

        let yAxisLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        yAxisLabel.center = CGPoint(x: 8, y: 285)
        yAxisLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        yAxisLabel.text = "Blood Sugar Level"
        self.view.addSubview(yAxisLabel)

    }

    
    func buildLineChart(){
        
        
        let glucoseFiles = Helper.getGlucose()
        self.glucoseLineData = glucoseFiles.map{ CGFloat($0.rawValue) }

        
        lineChart.addLine(glucoseLineData)
        let maxLine = Array(repeating: CGFloat(300), count: glucoseLineData.count)
        let minLine = Array(repeating: CGFloat(30), count: glucoseLineData.count)

        lineChart.addLine(maxLine)
        lineChart.addLine(minLine)
        
    }


    
    
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
//        let dateIndex = Int(x)
    }
    
    
    
}

