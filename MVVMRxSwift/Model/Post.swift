//
//  Post.swift
//  MVVMRxSwift
//
//  Created by Edo Oktarifa on 26/04/21.
//

import Foundation

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}
