//
//  UserToken.swift
//  yukimoto
//
//  Created by 雪本大樹 on 2017/11/06.
//  Copyright © 2017年 雪本大樹. All rights reserved.
//

import RealmSwift

class UserToken: Object {
    @objc dynamic var token = ""
    var userId:UInt64?
    
    static func create(_ tokenValue:String, userId:UInt64) -> UserToken {
        let userToken = UserToken()
        userToken.token = tokenValue
        userToken.userId = userId
        let realm = try! Realm()
        try! realm.write {
            realm.add(userToken)
        }
        return userToken
    }
    
    static func findSelfId() -> UInt64? {
        let realmObjects = try! Realm().objects(UserToken.self)
        if realmObjects.count > 0 {
            return realmObjects[0].userId
        }
        return nil
    }
}
