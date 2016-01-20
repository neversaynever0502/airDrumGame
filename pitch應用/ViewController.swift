//
//  ViewController.swift
//  pitch應用
//
//  Created by 顏楷霖 on 2015/12/9.
//  Copyright (c) 2015年 dct. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation


class ViewController: UIViewController {
    
    var yeah:Bool = true
    var bigDrum:AVAudioPlayer!
    var music:AVAudioPlayer!
    var mixDrum:AVAudioPlayer!
    var hihat:AVAudioPlayer!
    var snareDrum:AVAudioPlayer!
    var crash:AVAudioPlayer!
    
    var yesorno :Bool = false
    var choice :NSNumber = 0

    @IBOutlet weak var press: UIButton!

    @IBAction func touchUpInside(sender: AnyObject) {
//        yesorno = false
        choice = 0
    }
    @IBAction func touchUpOutside(sender: AnyObject) {
//          yesorno = false
//        choice = 2
        mixDrum.stop()
        mixDrum.currentTime = 0.0
        mixDrum.play()
    }
    @IBAction func touchDown(sender: AnyObject) {
//          yesorno = true
        choice = 1
    }
    //返回按钮事件
//    @IBAction func backButtonClick()
//    {
//        self.navigationController?.popViewControllerAnimated(true)
//    }
//    
    
    @IBOutlet var xLabel:UILabel!
    @IBOutlet var yLabel:UILabel!
    @IBOutlet var zLabel:UILabel!
    
    @IBOutlet var orientationLabel:UILabel!
    var timer:NSTimer?
    
    
    //加速计管理者-所有的操作都会由这个motionManager接管
    var motionManager:CMMotionManager!
    
    override func viewDidDisappear(animated: Bool) {
       
         music.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let path = NSBundle.mainBundle().pathForResource("bigdrum", ofType: "mp3")
        bigDrum = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(path!), error: nil)
        
        let path2 = NSBundle.mainBundle().pathForResource("girl", ofType: "mp3")
        music = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(path2!), error: nil)

        let path3 = NSBundle.mainBundle().pathForResource("over", ofType: "mp3")
        mixDrum = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(path3!), error: nil)
        
        let path4 = NSBundle.mainBundle().pathForResource("hihat", ofType: "mp3")
        hihat = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(path4!), error: nil)
        
        let path5 = NSBundle.mainBundle().pathForResource("snareDrum", ofType: "mp3")
        snareDrum = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(path5!), error: nil)
        
        let path6 = NSBundle.mainBundle().pathForResource("crash", ofType: "mp3")
        crash = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(path6!), error: nil)

        
        musicPlay()
        
        var x:Double = 0.4
        
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
                    self.zLabel.text = "Z:\(Int(accelerometerData!.acceleration.z*100))"
//                    self.view.backgroundColor = UIColor.whiteColor()
                }
            })
            
            
        }else
        {
            let aler = UIAlertView(title: "您的设备不支持加速计", message: nil, delegate: nil, cancelButtonTitle: "OK")
            aler.show()
        }
        
        
        
        //感知设备方向-开启监听设备方向
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        
        //添加通知，监听设备方向改变
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedRotation", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        //关闭监听设备方向
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
        
        
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var i = 0
    func acce(){
       
    
        
     
        if (yLabel.text!.toInt() > -50){
        
    println("ppp+\(i)")
          i++
            if choice == 0 {
                crash.stop()
                crash.currentTime = 0.0
                crash.play()
                view.backgroundColor = UIColor.blueColor()
                
            }
            else if choice == 1{
                hihat.stop()
                hihat.currentTime = 0.0
                hihat.play()
               
            
            }
//            else if choice == 2{
//                myPlayer3.stop()
//                myPlayer3.currentTime = 0.0
//                myPlayer3.play()
//            
//            }
            
            println(choice)
            
        }
        else if (xLabel.text!.toInt()>50){
            snareDrum.stop()
            snareDrum.currentTime = 0.0
            snareDrum.play()
view.backgroundColor = UIColor.redColor()
        
        
        }
        
    
    }
    
    func musicPlay(){
//    myPlayer2.stop()
//    myPlayer2.currentTime = 0.0
    music.play()
    
    }
    
    // MARK: - 判断设备方向代理方法
    func receivedRotation()
    {
        var device = UIDevice.currentDevice()
        
        if device.orientation == UIDeviceOrientation.Unknown
        {
            orientationLabel.text = "Unknown"
        }
        else if device.orientation == UIDeviceOrientation.Portrait
        {
            orientationLabel.text = "Portrait"
        }
        else if device.orientation == UIDeviceOrientation.PortraitUpsideDown
        {
            orientationLabel.text = "PortraitUpsideDown"
        }
        else if device.orientation == UIDeviceOrientation.LandscapeLeft
        {
            orientationLabel.text = "LandscapeLeft"
        }
        else if device.orientation == UIDeviceOrientation.LandscapeRight
        {
            orientationLabel.text = "LandscapeRight"
        }else if device.orientation == UIDeviceOrientation.FaceUp
        {
            orientationLabel.text = "FaceUp"
        }
        else  if device.orientation == UIDeviceOrientation.FaceDown
        {
            orientationLabel.text = "FaceDown"
        }
    }
    
    // MARK: - 摇晃事件
//    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent) {
//        
//        println("motionBegan")//开始摇晃
//    }
//    
//    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
//        println("motionEnded")//摇晃结束
//    }
//    
//    
//    override func motionCancelled(motion: UIEventSubtype, withEvent event: UIEvent) {
//        println("motionCancelled")//摇晃被意外终止
//    }


}

