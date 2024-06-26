//
//  QuoteService.swift
//  MVVM Using Combine
//
//  Created by Abdallah ismail on 25/06/2024.
//

import Foundation
import Combine
class QuoteService:QuoteServiceType {
    func getRandomQuot() -> AnyPublisher<Quote, any Error> {
        
     let url = URL(string: Constants.quoteUrl.rawValue)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }.map( {$0.data})
            .decode(type: Quote.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

}
