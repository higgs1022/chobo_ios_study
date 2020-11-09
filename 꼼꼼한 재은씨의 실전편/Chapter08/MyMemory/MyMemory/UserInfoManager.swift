//
//  UserInfoManager.swift
//  MyMemory
//
//  Created by Choi SeungHyuk on 2020/10/13.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import Alamofire

struct UserInfoKey {
    static let loginId = "LOGINID"
    static let account = "ACCOUNT"
    static let name = "NAME"
    static let profile = "PROFILE"
    static let tutorial = "TUTORIAL"
}

class UserInfoManager {
    var loginId: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserInfoKey.loginId)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.loginId)
            ud.synchronize()
        }
    }
    
    var account: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.account)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.account)
            ud.synchronize()
        }
    }
    
    var name: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.name)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.name)
            ud.synchronize()
        }
    }
    
    var profile: UIImage? {
        get {
            let ud = UserDefaults.standard
            if let _profile = ud.data(forKey: UserInfoKey.profile) {
                return UIImage(data: _profile)
            } else {
                return UIImage(named: "account.jpg")
            }
        }
        set(v) {
            if v != nil {
                let ud = UserDefaults.standard
                ud.set(v!.pngData(), forKey: UserInfoKey.profile)
                ud.synchronize()
            }
        }
    }
    
    var isLogin: Bool {
        if self.loginId == 0 || self.account == nil {
            return false
        } else {
            return true
        }
    }
    
    func login(account: String, passwd: String, success: (()->Void)? = nil, fail:((String)->Void)? = nil) {
        // 1. URL과 전송할 값 준비
           let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/login"
           let param: Parameters = [
             "account": account,
             "passwd" : passwd
           ]
           // 2. API 호출
           let call = AF.request(url, method: .post, parameters: param,
                                        encoding: JSONEncoding.default)
           // 3. API 호출 결과 처리
           call.responseJSON { res in
             // 3-1. JSON 형식으로 응답했는지 확인
            let result = try! res.result.get()
             guard let jsonObject = result as? NSDictionary else {
               fail?("잘못된 응답 형식입니다:\(result)")
               return
             }
             // 3-2. 응답 코드 확인. 0이면 성공
             let resultCode = jsonObject["result_code"] as! Int
             if resultCode == 0 { // 로그인 성공
               // 3-3. 로그인 성공 처리 로직이 여기에 들어갑니다.
               
             } else { // 로그인 실패
               let msg = (jsonObject["error_msg"] as? String) ?? "로그인이 실패했습니다."
               fail?(msg)
             }
           }
    }
    
    func logout() -> Bool {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: UserInfoKey.loginId)
        ud.removeObject(forKey: UserInfoKey.account)
        ud.removeObject(forKey: UserInfoKey.name)
        ud.removeObject(forKey: UserInfoKey.profile)
        ud.synchronize()
        return true
    }
}
