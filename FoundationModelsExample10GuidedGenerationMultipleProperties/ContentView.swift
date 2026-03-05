//
//  ContentView.swift
//  FoundationModelsExample10GuidedGenerationMultipleProperties
//
//  Created by Quanpeng Yang on 3/5/26.
//

import SwiftUI
import FoundationModels

// Top-level struct from the book example
@Generable
struct CityResponse {
    @Guide(description: "The name of the city")
    let city: String

    @Guide(description: "The name of the country the city belongs to")
    let country: String

    @Guide(description: "The main language spoken in the city")
    let language: String

    @Guide(description: "The currency used in the city")
    let currency: String

    @Guide(description: "A list of attractions in the city", .count(5))
    let attractions: [String]
}

struct ContentView: View {
    @State private var response = ""

    var body: some View {
        VStack {
            Button("Send") {
                let prompt = "Provide information about Paris."
                let instructions = """
                Return a JSON object matching the CityResponse structure.
                Include city name, country, main language, currency, and a list of 5 attractions.
                Do not include explanations.
                """

                let session = LanguageModelSession(instructions: instructions)

                let options = GenerationOptions(
                    sampling: .greedy,
                    temperature: 0.0,
                    maximumResponseTokens: 300
                )

                if !session.isResponding {
                    Task {
                        do {
                            let answer = try await session.respond(
                                to: prompt,
                                generating: CityResponse.self,
                                options: options
                            )

                            // Build a display string for demo
                            let cityInfo = answer.content
                            response = """
                            City: \(cityInfo.city)
                            Country: \(cityInfo.country)
                            Language: \(cityInfo.language)
                            Currency: \(cityInfo.currency)
                            Attractions: \(cityInfo.attractions.joined(separator: ", "))
                            """
                        } catch {
                            response = "Error accessing the model: \(error)"
                        }
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            Text(response)
                .font(.system(size: 16))
                .padding()
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding()
    }
}
