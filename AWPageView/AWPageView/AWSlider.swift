//
//  AWSlider.swift
//  AWPageView
//
//  Created by chloe on 2015. 11. 9..
//  Copyright © 2015년 chloe. All rights reserved.
//

import UIKit

class AWSlider: UIControl {
    
    @IBInspectable var value : Float
    
    @IBInspectable var minimumValue : Float
    @IBInspectable var maximumValue : Float
    
    @IBInspectable var minimumValueImage : UIImage
    @IBInspectable var maximumValueImage : UIImage
    
    @IBInspectable var minimumTrackTintColor : UIColor
//    @IBInspectable var currentMinimumTrackImage : UIColor
    
    @IBInspectable var maximumTrackTintColor : UIColor
//    @IBInspectable var currentMaximumTrackImage : UIColor
    
    @IBInspectable var thumbTintColor : UIColor
    
    @IBInspectable var currentThumbImage : UIImage
    
    @IBInspectable var thumbHeight : CGFloat
    @IBInspectable var sliderFrame : CGRect
    
    @IBInspectable var thumbTagTintColor : UIColor
    
//    var continuous : Bool
    var minimumTrack : UIView?
    var maximumTrack : UIView?
    var thumb : UIButton?
    
    var thumbTag : UIButton?

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        self.value = 30.0
        self.minimumValue = 0.0
        self.maximumValue = 100.0
        self.thumbHeight = 30.0
        self.sliderFrame = CGRect(x: 10.0, y: 30.0, width: 30.0, height: 450.0)
        self.minimumValueImage = UIImage.init()
        self.maximumValueImage = UIImage.init()
        self.minimumTrackTintColor = UIColor.whiteColor()
        self.maximumTrackTintColor = UIColor.whiteColor()
        self.thumbTintColor = UIColor.whiteColor()
        self.thumbTagTintColor = UIColor.whiteColor()
        self.currentThumbImage = UIImage.init()
        
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (self.minimumTrack == nil) {
            let origin = self.sliderFrame.origin
            let size = self.sliderFrame.size
            let percentage : Float = (value - minimumValue)/(maximumValue - minimumValue)
            let thumbY = size.height - thumbHeight - ((size.height - thumbHeight) * CGFloat(percentage))
            
            
            
            maximumTrack = UIView(frame: CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height))
            minimumTrack = UIView(frame: CGRect(x: 0.0, y: thumbY, width: size.width, height: size.height - thumbY))
            thumb = UIButton(frame: CGRect(x: 0.0, y:  0.0, width: size.width, height: thumbHeight))
            thumbTag = UIButton(frame: CGRect(x: size.width, y: -50.0, width: 50.0, height: 50.0))
            
            if let maxView: UIView = maximumTrack,
                minView: UIView = minimumTrack,
                button: UIButton = thumb,
                tag: UIButton = thumbTag {
                    maxView.backgroundColor = maximumTrackTintColor
                    minView.backgroundColor = minimumTrackTintColor
                    button.backgroundColor = thumbTintColor
                    tag.backgroundColor = thumbTagTintColor
                    
                    self.addSubview(maxView)
                    maxView.addSubview(minView)
                    minView.addSubview(button)
                    button.addSubview(tag)
                    
                    button.addTarget(self, action: "moveThumb:event:", forControlEvents: .TouchDragInside)
                    tag.addTarget(self, action: "moveThumb:event:", forControlEvents: .TouchDragInside)
            }
            
//            maximumTrack?.backgroundColor = maximumTrackTintColor
//            minimumTrack?.backgroundColor = minimumTrackTintColor
//            
//            thumb?.backgroundColor = thumbTintColor
//            
//            thumbTag?.backgroundColor = UIColor.brownColor()
//            
//            self.addSubview(maximumTrack!)
//            maximumTrack?.addSubview(minimumTrack!)
//            minimumTrack?.addSubview(thumb!)
//            thumb?.addSubview(thumbTag!)
//            
//            thumb?.addTarget(self, action: "moveThumb:event:", forControlEvents: .TouchDragInside)
//            thumbTag?.addTarget(self, action: "moveThumb:event:", forControlEvents: .TouchDragInside)
            
            
//            self.maximumTrack!.clipsToBounds = true
            
            // test....
//            let maxButton = UIButton(frame: CGRect(x: 0.0, y: -25.0, width: size.width, height: 50.0))
            //        maxButton.backgroundColor = UIColor.blackColor()
//            maxButton.setImage(UIImage(named: "Control"), forState: UIControlState.Normal)
//            self.addSubview(maxButton)
            //        maxButton.addTarget(self, action: "moveThumb:", forControlEvents: .TouchDragInside)
            
            
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
    
    func moveThumb(sender: UIButton!, event: UIEvent) {
        UIView.animateWithDuration(0.0, delay: 0.0, options: .TransitionNone, animations: {
            if let minFrame: CGRect = self.minimumTrack?.frame,
                touch: UITouch = event.touchesForView(sender)?.first,
                h: CGFloat = self.maximumTrack?.frame.size.height {
                    let prevLocation: CGPoint = touch.previousLocationInView(sender)
                    let location: CGPoint = touch.locationInView(sender)
                    let deltaY: CGFloat = location.y - prevLocation.y
                    var thumbY: CGFloat = minFrame.origin.y + deltaY
                    var thumbH: CGFloat = minFrame.size.height - deltaY
                    
                    if (thumbY < 0.0 || thumbY > h - self.thumbHeight) {
                        thumbY = minFrame.origin.y
                        thumbH = minFrame.size.height
                    }
                    
                    self.minimumTrack?.frame.origin.y = thumbY
                    self.minimumTrack?.frame.size.height = thumbH
            }
            
            
//            var minFrame = self.minimumTrack!.frame
//            
//            let touch: UITouch = event.touchesForView(sender)!.first! as UITouch
////            let touch: Set<UITouch> = event.touchesForView(sender)!
//            
//            let prevLocation: CGPoint = touch.previousLocationInView(sender)
//            let location: CGPoint = touch.locationInView(sender)
//            let deltaY: CGFloat = location.y - prevLocation.y
//            var thumbY: CGFloat = minFrame.origin.y + deltaY
//            var thumbH: CGFloat = minFrame.size.height - deltaY
//            
//            let h = self.maximumTrack!.frame.size.height
//            
//            if (thumbY < 0.0 || thumbY > h - self.thumbHeight) {
//                thumbY = minFrame.origin.y
//                thumbH = minFrame.size.height
//            }
//            
//            minFrame.origin.y = thumbY
//            minFrame.size.height = thumbH
//            self.minimumTrack?.frame = minFrame
            
            }, completion: { (finished: Bool) in
            return true
        })
    }

}
