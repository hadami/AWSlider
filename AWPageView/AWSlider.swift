//
//  AWSlider.swift
//  AWPageView
//
//  Created by chloe on 2015. 11. 9..
//  Copyright © 2015년 chloe. All rights reserved.
//

import UIKit

class AWSlider: UIControl {
    
    @IBInspectable var value: Float
    
    @IBInspectable var minimumValue: Float
    @IBInspectable var maximumValue: Float
    
    @IBInspectable var minimumValueImage: UIImage
    @IBInspectable var maximumValueImage: UIImage
    
    @IBInspectable var minimumTrackTintColor: UIColor
//    @IBInspectable var currentMinimumTrackImage : UIColor
    
    @IBInspectable var maximumTrackTintColor: UIColor
//    @IBInspectable var currentMaximumTrackImage : UIColor
    
    @IBInspectable var thumbTintColor: UIColor
    
//    @IBInspectable var currentThumbImage: UIImage
    
    @IBInspectable var thumbHeight: CGFloat
    @IBInspectable var sliderFrame: CGRect
    
    @IBInspectable var thumbTagTintColor: UIColor
    
    //    var continuous : Bool
    var minimumTrack: UIView?
    var maximumTrack: UIView?
    var thumb: UIButton?
    var thumbTag: UIButton?
    
    var maxBtn: UIButton?
    var minBtn: UIButton?
    
    required init?(coder aDecoder: NSCoder) {
        self.value = 70.0
        self.minimumValue = 60.0
        self.maximumValue = 100.0
        self.thumbHeight = 30.0
        self.sliderFrame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        self.minimumValueImage = UIImage.init()
        self.maximumValueImage = UIImage.init()
        self.minimumTrackTintColor = UIColor.whiteColor()
        self.maximumTrackTintColor = UIColor.whiteColor()
        self.thumbTintColor = UIColor.whiteColor()
        self.thumbTagTintColor = UIColor.whiteColor()
        
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (self.minimumTrack == nil) {
            sliderFrame = CGRect(x: 0.0, y: self.frame.size.width, width: self.frame.size.width, height: self.frame.size.height - self.frame.size.width*2)
            
            let origin = self.sliderFrame.origin
            let size = self.sliderFrame.size
            let percentage : Float = (value - minimumValue)/(maximumValue - minimumValue)
            let thumbY = size.height - thumbHeight - ((size.height - thumbHeight) * CGFloat(percentage))
            
            maxBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width:size.width , height: size.width))
            minBtn = UIButton(frame: CGRect(x: 0.0, y: size.height + size.width, width:size.width , height: size.width))
            maximumTrack = UIView(frame: CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height))
            minimumTrack = UIView(frame: CGRect(x: 0.0, y: thumbY, width: size.width, height: size.height - thumbY))
            thumb = UIButton(frame: CGRect(x: 0.0, y:  0.0, width: size.width, height: thumbHeight))
            thumbTag = UIButton(frame: CGRect(x: size.width, y: -50.0, width: 50.0, height: 50.0))
            
            
            
            if let max: UIButton = maxBtn,
                min: UIButton = minBtn,
                maxView: UIView = maximumTrack,
                minView: UIView = minimumTrack,
                button: UIButton = thumb,
                tag: UIButton = thumbTag {
                    max.setImage(UIImage(named: "Plus"), forState: .Normal)
                    min.setImage(UIImage(named: "Minus"), forState: .Normal)
                    
                    maxView.backgroundColor = maximumTrackTintColor
                    minView.backgroundColor = minimumTrackTintColor
                    button.backgroundColor = thumbTintColor
                    tag.backgroundColor = thumbTagTintColor
                    
                    self.addSubview(max)
                    self.addSubview(min)
                    self.addSubview(maxView)
                    maxView.addSubview(minView)
                    minView.addSubview(button)
                    button.addSubview(tag)
                    
                    max.addTarget(self, action: "moveMax", forControlEvents: .TouchUpInside)
                    min.addTarget(self, action: "moveMin", forControlEvents: .TouchUpInside)
                    button.addTarget(self, action: "moveThumb:event:", forControlEvents: .TouchDragInside)
                    tag.addTarget(self, action: "moveThumb:event:", forControlEvents: .TouchDragInside)
                    
                    tag.setTitle("\(value)", forState: UIControlState.Normal)
            }
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        // Convert the point to the target view's coordinate system.
        // The target view isn't necessarily the immediate subview
        if let view: UIButton = self.thumbTag,
            pointForThumbTag: CGPoint = view.convertPoint(point, fromView: self) {
                if (CGRectContainsPoint(view.bounds, pointForThumbTag)) {
                    // The target view may have its view hierarchy,
                    // so call its hitTest method to return the right hit-test view
                    return view.hitTest(pointForThumbTag, withEvent: event)
                }
        }
        return super.hitTest(point, withEvent: event)
    }
    
    func moveMax() {
        UIView.animateWithDuration(0.0, delay: 0.0, options: .TransitionNone, animations: {
            self.minimumTrack?.frame.origin.y = 0.0
            self.minimumTrack?.frame.size.height = self.sliderFrame.height
            
            self.value = self.maximumValue
            self.thumbTag?.setTitle("\(self.value)", forState: .Normal)
            
            }, completion: { (finished: Bool) in
                return true
        })
    }
    
    func moveMin() {
        UIView.animateWithDuration(0.0, delay: 0.0, options: .TransitionNone, animations: {
            self.minimumTrack?.frame.origin.y = self.sliderFrame.height - self.thumbHeight
            self.minimumTrack?.frame.size.height = self.thumbHeight
            
            self.value = self.minimumValue
            self.thumbTag?.setTitle("\(self.value)", forState: .Normal)
            
            }, completion: { (finished: Bool) in
                return true
        })
    }
    
    func moveThumb(sender: UIButton, event: UIEvent) {
        UIView.animateWithDuration(0.0, delay: 0.0, options: .TransitionNone, animations: {
            if let minFrame: CGRect = self.minimumTrack?.frame,
                touch: UITouch = event.touchesForView(sender)?.first,
                maxH: CGFloat = self.maximumTrack?.frame.size.height {
                    let prevLocation: CGPoint = touch.previousLocationInView(sender)
                    let location: CGPoint = touch.locationInView(sender)
                    let deltaY: CGFloat = location.y - prevLocation.y
                    let minY: CGFloat = minFrame.origin.y + deltaY
                    let minH: CGFloat = minFrame.size.height - deltaY
                    
                    if (minY < 0.0 || minY > maxH - self.thumbHeight) {
                        return
                    }
                    
                    self.minimumTrack?.frame.origin.y = minY
                    self.minimumTrack?.frame.size.height = minH
                    
                    let v: Float = Float(minY/(maxH - self.thumbHeight))
                    self.value = self.maximumValue - (self.maximumValue - self.minimumValue)*v
                    
                    self.thumbTag?.setTitle(String(format: "%.1f", self.value), forState: .Normal)
                    // TODO: value setting?
            }
            }, completion: { (finished: Bool) in
                return true
        })
    }

}
