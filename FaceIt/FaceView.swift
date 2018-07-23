//
//  FaceView.swift
//  FaceIt
//
//  Created by Rudolf Farkas on 23.07.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import UIKit

class FaceView: UIView {

    override func draw(_ rect: CGRect) {

        let skullRadius = min(bounds.width, bounds.height) / 2
        let skullCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
        path.lineWidth = 5.0
        UIColor.blue.set()
        path.stroke()
    }

}

