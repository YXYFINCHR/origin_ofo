//
//  InputController.swift
//  ofo
//
//  Created by YXY on 2017/9/9.
//  Copyright © 2017年 YXY. All rights reserved.
//

import UIKit
import APNumberPad

class InputController: UIViewController,APNumberPadDelegate,UITextFieldDelegate {
    
    var isFlashOn = false
    var isVoiceOn = true
    let defaults = UserDefaults.standard

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var goBtn: UIButton!
    
    @IBAction func goBtnTap(_ sender: UIButton) {
        checkPass()
    }
    
    @IBAction func flashBtnTap(_ sender: UIButton) {
        isFlashOn = !isFlashOn
        
        if isFlashOn {
            flashBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch"), for: .normal)
        } else {
            flashBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch"), for: .normal)
        }
    }
    
    @IBAction func voiceBtnTap(_ sender: UIButton) {
        isVoiceOn = !isVoiceOn
        
        if isVoiceOn {
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
            defaults.set(true, forKey: "isVoiceOn")
        } else {
            voiceBtn.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
            defaults.set(false, forKey: "isVoiceOn")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "车辆解锁"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "扫码用车", style: .plain, target: self, action: #selector(backToScan))
        navigationController?.navigationBar.tintColor = UIColor.black
        
//        inputTextField.layer.borderWidth = 2  及第58行功能 已在UIViewHelper中扩展，可在storyboard组件属性中直接设置
        
        // inputTextField.layer.borderColor = UIColor.yellow.cgColor    写法一
        // inputTextField.layer.borderColor = UIColor(red: 247/255, green: 215/255, blue: 80/255, alpha: 1).cgColor     写法二
        // borderColor类型为CGColor∈[0,1] alpha是透明度，0是完全透明 opacity是不透明度
        
//        inputTextField.layer.borderColor = UIColor.ofo.cgColor  //写法三
        
        let numberPad = APNumberPad(delegate: self)
        numberPad.leftFunctionButton.setTitle("确定", for: .normal)
        inputTextField.inputView = numberPad    //文本框.inputView就是指定键盘样式
        inputTextField.delegate = self  //指定代理以便控制输入字符数
        
        goBtn.isEnabled = false
        
        voiceBtnStatus(voiceBtn: voiceBtn)
//        if defaults.bool(forKey: "isVoiceOn") {
//            voiceBtn.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
//        }else{
//            voiceBtn.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
//        }
    }
    
    func numberPad(_ numberPad: APNumberPad, functionButtonAction functionButton: UIButton, textInput: UIResponder) {
        checkPass()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        let newLength = text.characters.count + string.characters.count - range.length
        
        if newLength > 0 {
            goBtn.setImage(#imageLiteral(resourceName: "nextArrow_enable"), for: .normal)
            goBtn.backgroundColor = UIColor.ofo
            goBtn.isEnabled = true
        } else {
            goBtn.setImage(#imageLiteral(resourceName: "nextArrow_unenable"), for: .normal)
            goBtn.backgroundColor = UIColor.groupTableViewBackground
            goBtn.isEnabled = false
        }
        
        return newLength <= 8
    }
    
    func backToScan(){
        navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var passArray:[String] = []
    
    
    func checkPass() {
        if !inputTextField.text!.isEmpty {  //第一个叹号表示取反，第二个叹号表示强制取值
            //NetworkHelper.getPass(code: <#T##Int#>, completion: <#T##(String?) -> Void#>)
            
            let code = inputTextField.text!
            
            NetworkHelper.getPass(code: code, completion: { (pass) in
                if let pass = pass{
//                    //"9999"转换为["9","9","9","9"]
//                    destVC.passArray = pass.characters.map{
                    self.passArray = pass.characters.map{
                        return $0.description
                    }
                    self.performSegue(withIdentifier: "showPasscode", sender: self)
                }else {
                    self.performSegue(withIdentifier: "showErrorView", sender: self)
                }
            })
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showPasscode" {
            let destVC = segue.destination as! showPasscodeController
            
            destVC.passArray = self.passArray   // 值的传递
        }
    }
}
