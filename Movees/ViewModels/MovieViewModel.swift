//
//  MovieViewModel.swift
//  Movees
//
//  Created by Timotius Tjahjadi  on 04/06/21.
//

import Foundation
import Combine

class MovieViewModel {
    
    //DI
    private let webService: APIManager
    private let endpoint: Endpoint
    
    var moviesSubject = PassthroughSubject<MovieResp, Error>()
    
    init(webService: APIManager, endpoint: Endpoint) {
        self.webService = webService
        self.endpoint = endpoint
    }
    
    func fetchMovie() {
        let url = URL(string: endpoint.urlString)!
        webService.fetchMovies(url: url) { [weak self] (result: Result<MovieResp, Error>) in
            switch result {
            case .success(let movies):
                self?.moviesSubject.send(movies)
            case .failure(let error):
                self?.moviesSubject.send(completion: .failure(error))
            }
        }
    }
}
