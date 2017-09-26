//
//  showPasscodeController.swift
//  ofo
//
//  Created by YXY on 2017/9/10.
//  Copyright © 2017年 YXY. All rights reserved.
//

import UIKit
import SwiftyTimer
import SwiftySound

class showPasscodeController: UIViewController {
    
    @IBOutlet weak var label_1st: myPreviewLabel!
    @IBOutlet weak var label_2nd: myPreviewLabel!
    @IBOutlet weak var label_3rd: myPreviewLabel!
    @IBOutlet weak var label_4th: myPreviewLabel!
    
    
    var code = ""
    var passArray:[String] = []//{    //属性监视器——当passArray数组有变化(后)立刻执行didSet中的语句
//        didSet{     //willSet：即将发生变化的时候进行的操作
//            self.label_1st.text = passArray[0]
//            self.label_2nd.text = passArray[1]
//            self.label_3rd.text = passArray[2]
//            self.label_4th.text = passArray[3]
//        }
//    }
    
    var remindSeconds = 121
    var isTorchOn = false
    var isVoiceOn = true
    let defaults = UserDefaults.standard
    

    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var torchBtn: UIButton!
    @IBOutlet weak var voiceBtn: UIButton!
    

    @IBAction func torchBtnTap(_ sender: UIButton) {
        turnTorch()
        
        if isTorchOn {
            torchBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch"), for: .normal)
        } else {
            torchBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch"), for: .normal)
        }
        
        isTorchOn = !isTorchOn
    }
    
    @IBAction func voiceBtnTap(_ sender: UIButton) {
        if isVoiceOn {
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
            defaults.set(true, forKey: "isVoiceOn")
        } else {
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
            defaults.set(false, forKey: "isVoiceOn")
        }
        isVoiceOn = !isVoiceOn
    }
    
    
    @IBAction func reportBtnTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)    //返回上一级 有导航就pop，没有导航就dismiss
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Timer.every(1){ (timer:Timer) in
            self.remindSeconds -= 1
            self.countDownLabel.text = self.remindSeconds.description    //.description为转为文本型
            
            if self.remindSeconds == 0{
                timer.invalidate()
            }
        }
        
        if defaults.bool(forKey: "isVoiceOn") {
            Sound.play(file: "上车前.m4a")
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
        }else{
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
        }
        
        self.label_1st.text = passArray[0]
        self.label_2nd.text = passArray[1]
        self.label_3rd.text = passArray[2]
        self.label_4th.text = passArray[3]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
