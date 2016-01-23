//
//  ViewController2.swift
//  pitch應用
//
//  Created by 顏楷霖 on 2016/1/19.
//  Copyright (c) 2016年 dct. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class ViewController2: UIViewController {
    
    var bigDrum:AVAudioPlayer!
    var music:AVAudioPlayer!
    var mixDrum:AVAudioPlayer!
    var hihat:AVAudioPlayer!
    var snareDrum:AVAudioPlayer!
    var choice :NSNumber = 0
    var timer:NSTimer?
    var motionManager:CMMotionManager!
    var number:NSNumber = 0

    @IBAction func touchUpInside(sender: AnyObject) {
        number = 0
    }
    @IBAction func touchDown(sender: AnyObject) {
        number = 1
    }
    
    @IBOutlet weak var orientationLabel: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("bigdrum", ofType: "mp3")
        bigDrum = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(path!), error: nil)
        let path5 = NSBundle.mainBundle().pathForResource("snareDrum", ofType: "mp3")
        snareDrum = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(path5!), error: nil)

        var x:Double = 0.8
        
        timer = NSTimer.scheduledTimerWithTimeInterval(x, target: self, selector: "acce", userInfo: nil, repeats: true)
        
        //------ CoreMotion 加速计
        motionManager = CMMotionManager()//注意CMMotionManager不是单例
        motionManager.accelerometerUpdateInterval = 0.1//设置读取时间间隔
        
        if motionManager.accelerometerAvailable//判断是否可以使用加速度计
        {
            //获取主线程并发队列,在主线程里跟新UI
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (var accelerometerData:CMAccelerometerData?, var error:NSError?) -> Void in
                
                if error != nil
                {
                    self.motionManager.stopAccelerometerUpdates()//停止使用加速度计
                }else
                {
                    
                    self.xLabel.text = "\(Int(accelerometerData!.acceleration.x*100))"
                    self.yLabel.text = "\(Int(accelerometerData!.acceleration.y*100))"
                    self.zLabel.text = "\(Int(accelerometerData!.acceleration.z*100))"
                    //                    self.view.backgroundColor = UIColor.whiteColor()
                }
            })
            
            
        }else
        {
            let aler = UIAlertView(title: "您的设备不支持加速计", message: nil, delegate: nil, cancelButtonTitle: "OK")
            aler.show()
        }
        
        
        
       // 感知设备方向-开启监听设备方向
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        
        //添加通知，监听设备方向改变
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedRotation", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        //关闭监听设备方向
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
        
        
        
    

        // Do any additional setup after loading the view.
    }
    
    
    

    func acce(){
    if (self.yLabel.text!.toInt() > -80){
        if(number==1){
            println(self.zLabel.text!)
            snareDrum.stop()
            snareDrum.currentTime = 0.0
            snareDrum.play()
        }
        else {
            bigDrum.stop()
            bigDrum.currentTime = 0.0
            bigDrum.play()
        }

        }
    }
    
    func receivedRotation()
    {
        var device = UIDevice.currentDevice()
        
        if device.orientation == UIDeviceOrientation.Unknown
        {
            orientationLabel.text = "Unknown"
        }
        else if device.orientation == UIDeviceOrientation.Portrait
        {
//               number = 0
            orientationLabel.text = "Portrait"
            
        }
        else if device.orientation == UIDeviceOrientation.PortraitUpsideDown
        {
            orientationLabel.text = "PortraitUpsideDown"
        }
        else if device.orientation == UIDeviceOrientation.LandscapeLeft
        {
//            number = 0
            orientationLabel.text = "LandscapeLeft"
        }
        else if device.orientation ==
            UIDeviceOrientation.LandscapeRight
        {
//              number = 0
            orientationLabel.text = "LandscapeRight"
        }else if device.orientation == UIDeviceOrientation.FaceUp
        {
//            number = 1
            orientationLabel.text = "FaceUp"
            
        }
        else  if device.orientation == UIDeviceOrientation.FaceDown
        {
            orientationLabel.text = "FaceDown"
        }
    }


     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 摇晃事件
//        override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent) {
//    
//            println("motionBegan")//开始摇晃
////            if(self.zLabel.text!.toInt() < -50){
//                  }
//    
//        override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
//            println("motionEnded")//摇晃结束
//        }
//    
//    
//        override func motionCancelled(motion: UIEventSubtype, withEvent event: UIEvent) {
//            println("motionCancelled")//摇晃被意外终止
//        }
//
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
