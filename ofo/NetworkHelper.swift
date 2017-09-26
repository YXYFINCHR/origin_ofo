//
//  NetworkHelper.swift
//  ofo
//
//  Created by YXY on 2017/9/12.
//  Copyright © 2017年 YXY. All rights reserved.
//
import AVOSCloud


struct NetworkHelper {
    
}

extension NetworkHelper{
    static func getPass(code: String, completion: @escaping (String?) -> Void) {   //@escaping：表示该闭包即使在函数运行完后还能用
        let query = AVQuery(className: "Code")
        
        query.whereKey("code", equalTo: code)   //在(第一个)code表中查询和传入参数(Int型)code(车牌号)相等的值
        
        query.getFirstObjectInBackground { (code, e) in
            if let e = e{
                print("出错，",e.localizedDescription)
                completion(nil)
            }
            if let code = code, let pass = code["pass"] as? String{
                completion(pass)
            }
        }
    }
}
