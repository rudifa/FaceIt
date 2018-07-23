//
//  FaceView.swift
//  FaceIt
//
//  Created by Rudolf Farkas on 23.07.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import UIKit

class FaceView: UIView {

    var scale: CGFloat = 0.9
    var eyesOpen = false

    private var skullRadius: CGFloat {
        return min(bounds.width, bounds.height) / 2 * scale
    }

    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    private enum Eye {
        case left, right
    }

    private func pathForEye(_ eye: Eye) -> UIBezierPath {
        func centerOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
            return eyeCenter
        }
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)

        let path: UIBezierPath
        if eyesOpen {
            path = pathForCircle(center: eyeCenter, radius: eyeRadius)
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        path.lineWidth = 5.0
        return path
    }

    private func pathForCircle(center: CGPoint, radius: CGFloat)  -> UIBezierPath {
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
    }

    private func pathForSkull() -> UIBezierPath {
        let path = pathForCircle(center: skullCenter, radius: skullRadius)
        path.lineWidth = 5.0
        return path
    }

    override func draw(_ rect: CGRect) {

        UIColor.blue.set()
        pathForSkull().stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
    }

    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 3
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
    }

}

