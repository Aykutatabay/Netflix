//
//  APICaller.swift
//  Netflix
//
//  Created by Aykut ATABAY on 30.01.2023.
//

import Foundation

struct Constants {
    static let API_KEY = "a31302215b7310216a39697e55145a16"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyBomX0uzR36EVt8aJBayY9qkwsxGAPkGWs"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}


enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> () ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=a31302215b7310216a39697e55145a16") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            print("works")
            guard let data = data,
               error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> ()) {
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/tv/day?api_key=a31302215b7310216a39697e55145a16") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,
                  error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> () ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=a31302215b7310216a39697e55145a16&language=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            print("works")
            guard let data = data,
               error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> () ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_keya31302215b7310216a39697e55145a16&language=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,
               error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
        
        
    }
    
    
    func getTopRatedMovies(completion: @escaping (Result<[Title], Error>) -> () ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=a31302215b7310216a39697e55145a16&language=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,
               error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> () ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,
               error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> () ) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string:"https://api.themoviedb.org/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,
               error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    func getMoview(with query: String, completion: @escaping (Result<VideoElement, Error>) -> () ) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "https://youtube.googleapis.com/youtube/v3/search?q=\(query)&key=AIzaSyBomX0uzR36EVt8aJBayY9qkwsxGAPkGWs") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,
               error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                
                completion(.success(result.items[0]))
                
            } catch {
                completion(.failure(error))
                print(error.localizedDescription,"aykut")
            }
        }
        task.resume()
    }
    
}


