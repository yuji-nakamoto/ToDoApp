//
//  CustomSlider.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/29.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
    
    @IBInspectable var trackHeight: CGFloat = 4
    @IBInspectable var thumbRadius: CGFloat = 20

    private lazy var thumbView: UIView = {
        
        let thumb = UIView()
        thumb.layer.shadowOpacity = 1.0
        thumb.layer.shadowRadius = 3
        thumb.layer.backgroundColor = UIColor.white.cgColor
        thumb.layer.shadowOffset = CGSize(width: 0, height: 1)
        thumb.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        return thumb
    }()

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let thumb = thumbImage(diameter: thumbRadius)
        setThumbImage(thumb, for: .normal)
        
        let heighLightThumb = thumbImage(diameter: thumbRadius * 1.2)
        setThumbImage(heighLightThumb, for: .highlighted)
    }
    
    
    private func thumbImage(diameter: CGFloat) -> UIImage {
        
        thumbView.frame = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        thumbView.layer.cornerRadius = diameter / 2
        
        let renderer = UIGraphicsImageRenderer(bounds: CGRect(x: -(diameter * 0.5 / 2), y: -(diameter * 0.5 / 2), width: diameter * 1.5, height: diameter * 1.5))
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {

        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
}
