//
//  PostData.swift
//  HackerNews
//
//  Created by Александр Воробьев on 06.07.2020.
//  Copyright © 2020 Александр Воробьев. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let hits: [Post]
}

struct Post: Decodable, Identifiable {
    var id: String {
        objectID
    }
    let objectID: String
    let points: Int
    let title: String
    let url: String?
}
