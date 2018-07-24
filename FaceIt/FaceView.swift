//
//  FaceView.swift
//  FaceIt
//
//  Created by Rudolf Farkas on 23.07.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {

    @IBInspectable
    var scale: CGFloat = 0.9

    @IBInspectable
    var eyesOpen: Bool = false

    @IBInspectable
    var mouthCurvature: CGFloat = 1.0 // 1.0 is full smile, -1.0 is full frown

    @IBInspectable
    var lineWidth: CGFloat = 5.0

    @IBInspectable
    var lineColor: UIColor = .blue

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
        path.lineWidth = lineWidth
        return path
    }

    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        let mouthRect = CGRect(
            x: skullCenter.x - mouthWidth / 2,
            y: skullCenter.y + mouthOffset,
            width: mouthWidth, height: mouthHeight)

        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height

        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)

        let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthRect.width / 3, y: start.y + smileOffset)

        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }

    private func pathForCircle(center: CGPoint, radius: CGFloat)  -> UIBezierPath {
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
    }

    private func pathForSkull() -> UIBezierPath {
        let path = pathForCircle(center: skullCenter, radius: skullRadius)
        path.lineWidth = lineWidth
        return path
    }

    override func draw(_ rect: CGRect) {

        lineColor.set()
        pathForSkull().stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
    }

    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
    }

}

