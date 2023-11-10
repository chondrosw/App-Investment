//
//  ApiService.swift
//  App Investment
//
//  Created by Chondro Satrio Wibowo on 10/11/23.
//

import Foundation
import Combine

struct ApiService {
    let API_KEY = "BM2E87ILGE3QK9TG"
    
    func fetchSumbolsPublisher(keywords:String)-> AnyPublisher<SearchResults, Error> {
        let stringUrl = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        let url = URL(string: stringUrl)!
        return URLSession.shared.dataTaskPublisher(for: url).map({ $0.data })
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
