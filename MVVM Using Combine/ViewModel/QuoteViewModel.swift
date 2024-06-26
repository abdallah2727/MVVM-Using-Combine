//
//  QuoteViewModel.swift
//  MVVM Using Combine
//
//  Created by Abdallah ismail on 26/06/2024.
//

import Foundation
import Combine
class QuoteViewModel {
    enum Input {
        case viewDidAppear
        case refreshButtonDidTapped
        
    }
    enum Output {
        case fetchQuateDidFail (error:Error)
        case fetchQuateDidSucceed (quote:Quote)
        case toggleButton (isEnabled :Bool)
    }
    private let quotteserviceType:QuoteServiceType
    private let output : PassthroughSubject <Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(quotteserviceType: QuoteServiceType = QuoteService()) {
        self.quotteserviceType = quotteserviceType
    }
    func transform (input : AnyPublisher<Input,Never>) -> AnyPublisher <Output,Never>{
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear , .refreshButtonDidTapped:
                self?.handleGetRandomQuote()
                
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    private func handleGetRandomQuote () {
        output.send(.toggleButton(isEnabled: false))
        self.quotteserviceType.getRandomQuot().sink { completion in
            self.output.send(.toggleButton(isEnabled: true))
            if case .failure (let error) = completion {
                self.output.send(.fetchQuateDidFail(error: error))
            }
            
        } receiveValue: { [weak self] quote in
            self?.output.send(.fetchQuateDidSucceed(quote: quote))
        }.store(in: &cancellables)
    }
}
