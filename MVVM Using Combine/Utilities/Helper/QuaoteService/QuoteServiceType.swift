//
//  QuoteServiceType.swift
//  MVVM Using Combine
//
//  Created by Abdallah ismail on 25/06/2024.
//

import Foundation
import Combine
protocol QuoteServiceType {
    func getRandomQuot() -> AnyPublisher<Quote,Error>
}
