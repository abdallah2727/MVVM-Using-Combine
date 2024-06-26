//
//  ViewController.swift
//  MVVM Using Combine
//
//  Created by Abdallah ismail on 25/06/2024.
//

import UIKit
import Combine
class QuoteViewController: UIViewController {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var quoteLabel: UILabel!
    private let vm = QuoteViewModel()
    private let input: PassthroughSubject<QuoteViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
      bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.viewDidAppear)
    }
    private func bind(){
        let output = vm.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            switch event {
            case .fetchQuateDidFail(let error):
                self?.quoteLabel.text = error.localizedDescription
                self?.authorLabel.text = ""
                self?.refreshButton.isEnabled = false
            case .fetchQuateDidSucceed(let quote):
                self?.quoteLabel.text = quote.content
                self?.authorLabel.text = "By: "+quote.author
            case .toggleButton(let isEnabled):
                self?.refreshButton.isEnabled = isEnabled
            }
        }.store(in: &cancellables)
        
    }

    @IBAction func refreshButtonTapped(_ sender: Any) {
        input.send(.refreshButtonDidTapped)
    }
}

