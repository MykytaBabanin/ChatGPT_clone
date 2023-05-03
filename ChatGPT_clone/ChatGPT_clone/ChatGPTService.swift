//
//  ChatGPTService.swift
//  ChatGPT_clone
//
//  Created by Mykyta Babanin on 03.05.2023.
//

import Foundation
import OpenAISwift

@MainActor
class ChatGPTService: ObservableObject {
    private var openAI: OpenAISwift?
    @Published var answers = [String]()
    @Published var isLoading = false
    
    func setup() {
        openAI = OpenAISwift(authToken: "MyKey")
    }
    
    func predictInput(text: String) async {
        do {
            isLoading = true
            if let result = try await openAI?.sendCompletion(with: text,
                                                             model: .gpt3(.davinci),
                                                             maxTokens: 100,
                                                             temperature: 1) {
                isLoading = false
                answers.append(result.choices?.first?.text ?? "no answer")
            }
        } catch {
            isLoading = false
            print(error)
        }
    }
}
