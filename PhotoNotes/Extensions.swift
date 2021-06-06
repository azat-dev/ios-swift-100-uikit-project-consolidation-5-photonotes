//
//  Extensions.swift
//  PhotoNotes
//
//  Created by Azat Kaiumov on 05.06.2021.
//

import Foundation
import UIKit

extension FileManager {
    static func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.count > 0 ? paths[0] : nil
    }
}

extension UIFont {
    static func preferredFont(forTextStyle style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}

extension UIView {
    func shake(maxAmplitude: Double = 20.0) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [
            -maxAmplitude,
            maxAmplitude,
            -maxAmplitude,
            maxAmplitude,
            -maxAmplitude / 2,
            maxAmplitude / 2,
            -maxAmplitude / 4,
            maxAmplitude / 4,
            0.0
        ]
        layer.add(animation, forKey: "shake")
    }
}
