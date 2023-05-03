//
//  ContentView.swift
//  ChatGPT_clone
//
//  Created by Mykyta Babanin on 03.05.2023.
//

import SwiftUI
import OpenAISwift

struct ContentView: View {
    @ObservedObject var openAI = ChatGPTService()
    
    var body: some View {
        ChatInterfaceView(openAI: openAI)
    }
}

struct LoadingAnimationView: View {
    @State private var animationAmount = 0.0
    
    var body: some View {
        HStack {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 30, height: 25)
                    .scaleEffect(animationAmount)
                    .opacity(Double(3 - index) / 3)
                    .animation(.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true)
                        .delay(0.25 * Double(index)), value: animationAmount)
                
            }
        }
        .onAppear {
            animationAmount = 1
        }
    }
}

struct LoadingOverlay: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                LoadingAnimationView()
            }
        }
    }
}

struct ChatInterfaceView: View {
    @ObservedObject var openAI: ChatGPTService
    @State private var textInput = ""
    
    var body: some View {
        VStack {
            List(openAI.answers, id: \.self) { answer in
                Text(answer)
                    .listRowBackground(Color.yellow)
            }
            .modifier(LoadingOverlay(isLoading: openAI.isLoading))
            
            Spacer()
            HStack {
                TextField("Type text...", text: $textInput)
                    .disabled(openAI.isLoading)
                    .padding()
                
                Button("Submit") {
                    Task {
                        await openAI.predictInput(text: textInput)
                        textInput = ""
                    }
                }
                .disabled(openAI.isLoading)
                .padding()
            }
            .onAppear(perform: {
                openAI.setup()
            })
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black))
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
