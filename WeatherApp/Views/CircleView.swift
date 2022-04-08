//
//  CircleView.swift
//  WeatherApp
//
//  Created by Raul Shafigin on 06.04.2022.
//

import UIKit
@IBDesignable

class CircleView: UIView {
    override func draw(_ rect: CGRect) {
        let pathRect = CGRect(x: 1, y: 1, width: rect.width-2, height: rect.height-2)
        let path =  UIBezierPath(roundedRect: pathRect, cornerRadius: pathRect.width / 2)
        print(pathRect.width)
        let color = UIColor.black
        color.setStroke()
        path.stroke()
        
        let pathFirstLine = UIBezierPath()
        pathFirstLine.move(to: CGPoint(x: 50, y: 100))
        pathFirstLine.addLine(to: CGPoint(x: 50, y: 70))
        pathFirstLine.stroke()
        
        let pathSecondLine = UIBezierPath()
        pathSecondLine.move(to: CGPoint(x: 50, y: 30))
        pathSecondLine.addLine(to: CGPoint(x: 50, y: 0))
        pathSecondLine.stroke()
        
        let pathDirect = UIBezierPath()
        pathDirect.move(to: CGPoint(x: 50, y: 0))
        pathDirect.addLine(to: CGPoint(x: 45, y: 10))
        pathDirect.addLine(to: CGPoint(x: 55, y: 10))
        pathDirect.addLine(to: CGPoint(x: 50, y: 0))
        pathDirect.fill()
//
//        let swPathLine = UIBezierPath()
//        swPathLine.move(to: CGPoint(x: 85, y: 15))
//        swPathLine.addLine(to: CGPoint(x: 90, y: 10))
//        swPathLine.lineWidth = 3
//        swPathLine.stroke()
        
        let nePathLine = UIBezierPath()
        nePathLine.move(to: CGPoint(x: 49 + -49 * sqrt(2) / 2, y: 49 + 49 * sqrt(2) / 2 ))
        nePathLine.addLine(to: CGPoint(x: 49 + -49 * sqrt(2) / 2 - 5, y: 49 + 49 * sqrt(2) / 2 + 5))
        nePathLine.lineWidth = 3
        nePathLine.stroke()
        
        let sePathLine = UIBezierPath()
        sePathLine.move(to: CGPoint(x: 49 + -49 * sqrt(2) / 2, y: 49 + -49 * sqrt(2) / 2 ))
        sePathLine.addLine(to: CGPoint(x: 49 + -49 * sqrt(2) / 2 - 5, y: 49 + -49 * sqrt(2) / 2 - 5))
        sePathLine.lineWidth = 3
        sePathLine.stroke()
        
        let swPathLine = UIBezierPath()
        swPathLine.move(to: CGPoint(x: 49 + 49 * sqrt(2) / 2, y: 49 + -49 * sqrt(2) / 2 ))
        swPathLine.addLine(to: CGPoint(x: 49 + 49 * sqrt(2) / 2 + 5, y: 49 + -49 * sqrt(2) / 2 - 5))
        swPathLine.lineWidth = 3
        swPathLine.stroke()
        
        let nwPathLine = UIBezierPath()
        nwPathLine.move(to: CGPoint(x: 49 + 49 * sqrt(2) / 2, y: 49 + 49 * sqrt(2) / 2 ))
        nwPathLine.addLine(to: CGPoint(x: 49 + 49 * sqrt(2) / 2 + 5, y: 49 + 49 * sqrt(2) / 2 + 5))
        nwPathLine.lineWidth = 3
        nwPathLine.stroke()
        
        
        //tempFunc()
    }
    
    private func tempFunc() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 50))
        path.addLine(to: CGPoint(x: 100, y: 50))
        path.stroke()
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 50, y: 0))
        path2.addLine(to: CGPoint(x: 50, y: 100))
        
        path2.stroke()
    }
   
}
