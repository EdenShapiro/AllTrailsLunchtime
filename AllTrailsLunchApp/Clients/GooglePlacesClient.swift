//
//  GooglePlacesClient.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 6/30/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import UIKit

class GooglePlacesClient {
    static var shared = GooglePlacesClient()
    private var apiKey: String = ""
    private let jsonDecoder: JSONDecoder
    private var urlSession = URLSession(configuration: .default)
    private var baseURL = "https://maps.googleapis.com/maps/api/place"
    
    private init() {
        jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        if let key = APIKeys.keyForAPI(named: "googlePlacesKey") {
            apiKey = key
        } else {
            //            apiKey = ""
            assertionFailure("Google Places API key not found")
        }
    }
    
    //https://maps.googleapis.com/maps/api/place/textsearch/json?query=123+main+street&location=42.3675294,-71.186966&radius=10000&key=YOUR_API_KEY
    func findRestaurants(with query: String? = nil, longitude: Double, latitude: Double, completion:  @escaping (([Place]?, Error?) -> Void)) {
        
        let query = query?.components(separatedBy: .whitespacesAndNewlines).joined(separator: "+") ?? "restaurant"
        let params = "query=\(query)&location=\(latitude),\(longitude)&radius=3000&type=restaurant&key=\(apiKey)"
        let method = "textsearch"
        
        let urlString = "\(baseURL)/\(method)/json?\(params)"
        
        makeNetworkRequest(urlString: urlString) { (data, error) in
            var places: [Place]? = nil
            var error: Error?
            defer {
                DispatchQueue.main.async {
                    completion(places, error)
                }
            }
            guard let data = data else {
                error = error ?? InternalError(title: "Data Error", message: "No data found")
                return
            }
            
            do {
//                if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]  {
//                    print(dict)
//                }
                let decoded = try self.jsonDecoder.decode(SearchResponse.self, from: data)
                places = decoded.results
            } catch let e {
                error = e //?? InternalError(title: "JSON Error", message: "Failed to decode JSON")
            }
        }
    }
    
    // Get photo from photoReference
    //https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CnRtAAAATLZNl354RwP_9UKbQ_5Psy40texXePv4oAlgP4qNEkdIrkyse7rPXYGd9D_Uj1rVsQdWT4oRz4QrYAJNpFX7rzqqMlZw2h2E2y5IKMUZ7ouD_SlcHxYq1yL4KbKUv3qtWgTK0A6QbGh87GB3sscrHRIQiG2RrmU_jF4tENr9wGS_YxoUSSDrYjWmrNfeEHSGSc3FyhNLlBU&key=YOUR_API_KEY
    func getPhotoForReference(photoReference: String, completion: @escaping (UIImage?, String, Error?) -> ()) {
        let params = "maxwidth=400&photoreference=\(photoReference)&key=\(apiKey)"
        let method = "photo"
        let urlString = "\(baseURL)/\(method)?\(params)"

        makeNetworkRequest(urlString: urlString) { (data, err) in
            var image: UIImage?
            var error: Error?
            defer {
                DispatchQueue.main.async {
                    completion(image, photoReference, error)
                }
            }
            if let data = data, let img = UIImage(data: data) {
                image = img
            } else {
                error = err ?? InternalError(title: "Image Failure", message: "Failed to decode image data")
            }
        }
    }
    
    private func makeNetworkRequest(urlString: String, completion: @escaping ((Data?, Error?) -> Void)) {
        guard let url = URL(string: urlString) else {
            let error = InternalError(title: "URL error", message: "Cannot form url from given string")
            completion(nil, error)
            return
        }
        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10)
        request.httpMethod = "GET"
        DispatchQueue.global(qos: .userInitiated).async {
            self.urlSession.dataTask(with: request) { (data, response, error) in
                var clientError: ClientError? = nil
                if let error = error {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                    clientError = ClientError(status: statusCode, title: "Client Error", message: error.localizedDescription)
                }
                completion(data, clientError)
            }.resume()
        }
    }
    
}
