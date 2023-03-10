//
//  UserRepository.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thai on 20/12/2022.
//

import Foundation
final class UserRepository: APIRespository {
    private let callAPI = APICaller.shared
    
    func getDataUser(name: String, completion: @escaping (UserDetail?, Error?) -> Void) {
        callAPI.getJSON(urlApi: "\(ConstantsAPI.informUser.rawValue)\(name)") { (data: UserDetail?, error) in
            if let data = data {
                completion(data, nil)
            }
        }
    }
    
    func getFollowers(name: String, completion: @escaping ([UserModel]?, Error?) -> Void) {
        callAPI.getJSON(urlApi: "\(ConstantsAPI.informUser.rawValue)\(name)/followers") { (data: [UserModel]?, error) in
            if let data = data {
                completion(data, nil)
            }
        }
    }
    
    func getFollowing(name: String, completion: @escaping ([UserModel]?, Error?) -> Void) {
        callAPI.getJSON(urlApi: "\(ConstantsAPI.informUser.rawValue)\(name)/following") { (data: [UserModel]?, error) in
            if let data = data {
                completion(data, nil)
            }
        }
    }
    
    func getUsersByName(name: String, completion: @escaping ([UserModel]?, Error?) -> Void) {
        callAPI.getJSON(urlApi: "\(ConstantsAPI.baseURL.rawValue)search/users?q=\(name)") { (data: Users?, error) in
            if let data = data {
                completion(data.items, nil)
            }
        }
    }
}
