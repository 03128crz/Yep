//
//  Waver.swift
//  Waver-Swift
//
//  Created by kevinzhow on 15/4/1.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

import UIKit

class Waver: UIView {
    
    var numberOfWaves: Int = 5
    
    var waveColor: UIColor = UIColor(red: 50/255.0, green: 167/255.0, blue: 255/255.0, alpha: 1.0)
    
    private var phase: CGFloat = 0
    
    var level: CGFloat! {
        didSet {
            self.phase+=self.phaseShift; // Move the wave
            self.amplitude = fmax( level, self.idleAmplitude)
            self.updateMeters()
        }
    }
    
    var mainWaveWidth: CGFloat = 2.0
    
    var decorativeWavesWidth: CGFloat = 1.0
    
    var idleAmplitude: CGFloat = 0.01
    
    var frequency: CGFloat = 1.2
    
    internal private(set) var amplitude: CGFloat = 1.0
    
    var density: CGFloat = 1.0
    
    var phaseShift: CGFloat = -0.25
    
    internal private(set) var waves: NSMutableArray = []
    
    //
    
    private var waveHeight: CGFloat!
    private var waveWidth: CGFloat!
    private var waveMid: CGFloat!
    private var maxAmplitude: CGFloat!

    var waverCallback: (() -> ())? {
        didSet {
            let displayLink = CADisplayLink(target: self, selector: Selector("callbackWaver"))
            displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
            
            for var i = 0; i < self.numberOfWaves; ++i {
                var waveline = CAShapeLayer()
                waveline.lineCap       = kCALineCapButt
                waveline.lineJoin      = kCALineJoinRound
                waveline.strokeColor   = UIColor.clearColor().CGColor
                waveline.fillColor     = UIColor.clearColor().CGColor
                waveline.lineWidth = (i==0 ? self.mainWaveWidth : self.decorativeWavesWidth)

                var floatI = CGFloat(i)
                var progressIndex = floatI/CGFloat(self.numberOfWaves)
                var progress = 1.0 - progressIndex
                var multiplier = min(1.0, (progress/3.0*2.0) + (1.0/3.0))
                
                waveline.strokeColor   = waveColor.colorWithAlphaComponent(( i == 0 ? 1.0 : 1.0*multiplier*0.4)).CGColor
                
                self.layer.addSublayer(waveline)
                self.waves.addObject(waveline)
            }
            
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        
        self.waveHeight = CGRectGetHeight(self.bounds) * 0.9
        self.waveWidth = CGRectGetWidth(self.bounds)
        self.waveMid = self.waveWidth/2.0
        self.maxAmplitude = self.waveHeight - 4.0
        
    }
    
    func callbackWaver() {
        waverCallback!()
    }
    
    private func updateMeters() {
        UIGraphicsBeginImageContext(self.frame.size)
        
        for var i=0; i < self.numberOfWaves; ++i {
            
            
            var wavelinePath = UIBezierPath()
            
            // Progress is a value between 1.0 and -0.5, determined by the current wave idx, which is used to alter the wave's amplitude.
            var progress = 1.0 - CGFloat(i)/CGFloat(self.numberOfWaves)
            var normedAmplitude = (1.5*progress-0.5)*self.amplitude
            
            
            for var x = 0 as CGFloat; x<self.waveWidth + self.density; x += self.density {
                
                //Thanks to https://github.com/stefanceriu/SCSiriWaveformView
                // We use a parable to scale the sinus wave, that has its peak in the middle of the view.
                var scaling = -pow(x/self.waveMid-1, 2) + 1 // make center bigger
                
                var y = scaling*self.maxAmplitude*normedAmplitude
                var temp = 2.0*CGFloat(M_PI)*(x/self.waveWidth)*self.frequency
                var temp2 = temp+self.phase
                y = CGFloat(y)*CGFloat(sinf(Float(temp2))) + self.waveHeight
                
                if (x==0) {
                    wavelinePath.moveToPoint(CGPointMake(x, y))
                }
                else {
                    wavelinePath.addLineToPoint(CGPointMake(x, y))
                }
            }
            
            var waveline = self.waves.objectAtIndex(i) as! CAShapeLayer
            waveline.path = wavelinePath.CGPath
            
        }
        
        UIGraphicsEndImageContext()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
