//
//  UIViewHelper.swift
//  ofo
//
//  Created by YXY on 2017/9/10.
//  Copyright © 2017年 YXY. All rights reserved.
//

extension UIView{   //以下扩展的是计算属性
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    //加了@IBInspectable修饰符后可以在storyboard属性栏中显示，以“车辆解锁”页面的label为例，它也是一种UIView，这里扩展了UIView的两个属性
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
}

@IBDesignable class myPreviewLabel:UILabel{ //@IBDesignable所见即所得标签 这样就能让所有被指定为myPreviewLabel类的控件属性所见即所得
    
}

@IBDesignable class myPreviewButton:UIButton{
    
}




//控制后置闪光灯
import AVFoundation

func turnTorch() {
    guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }
    
    if device.hasTorch && device.isTorchAvailable{
        try? device.lockForConfiguration()
        
        if device.torchMode == .off{
            device.torchMode = .on
        }else{
            device.torchMode = .off
        }
        
        device.unlockForConfiguration()
    }
}



func voiceBtnStatus(voiceBtn:UIButton) {
    
    let defaults = UserDefaults.standard
    
    if defaults.bool(forKey: "isVoiceOn") {
        voiceBtn.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
    }else{
        voiceBtn.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
    }
}








