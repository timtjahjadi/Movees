//
//  Utils.swift
//  Movees
//
//  Created by Timotius Tjahjadi  on 05/06/21.
//

import Foundation

enum Endpoint {
    case popular
    case upcoming
    
    var urlString: String {
        let apiKey = "?api_key=9794a02279457ff1dd616a586f2c8831"
        
        switch self {
        case .popular:
            return "https://api.themoviedb.org/3/movie/popular" + apiKey
        case .upcoming:
            return "https://api.themoviedb.org/3/movie/upcoming" + apiKey
        }
    }
}

