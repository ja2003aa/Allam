//
//  NetworkManager.swift
//  MinimalKeyboardTest
//
//  Created by Jana Algurashi on 01/11/2024.
//

import Foundation

class NetworkManager {
    
    static func fetchPoemAndSaveToAppGroup() {
        // Retrieve the prompt from App Group
        guard let sharedDefaults = UserDefaults(suiteName: "group.m.MinimalKeyboardTest"),
              let prompt = sharedDefaults.string(forKey: "promptText") else {
            print("No prompt found in App Group")
            return
        }
        
        // Create the URL for the server
        guard let url = URL(string: "http://192.168.8.127:8080/generate_poem") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the request body with the retrieved prompt
        let json: [String: Any] = ["prompt": prompt]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }

            if let data = data {
                // Save the poem to the App Group
                sharedDefaults.set(data, forKey: "poemData")
                sharedDefaults.synchronize()
                print("Poem data saved to App Group")
            }
        }
        task.resume()
    }
}
