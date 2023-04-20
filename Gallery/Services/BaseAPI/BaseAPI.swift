//
//  BaseAPI.swift
//  Gallery
//
//  Created by Marek Baláž on 19/04/2023.
//

import Foundation

protocol BaseAPIProtocol {
    var baseURL: String { get }
    func getPhotos(onAlbum: @escaping (NetworkService.Handler))
    func getAlbum(albumId: Int, onAlbum: @escaping (NetworkService.Handler))
}

extension NetworkService: BaseAPIProtocol {
    
    var baseURL: String {
        get {
            return Const.getStringFor(key: "BaseAPI")
        }
    }
    
    private func baseHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        return headers
    }
    
    public func getPhotos(onAlbum: @escaping (NetworkService.Handler)) {
        let headers = baseHeaders()
        if let url: URL = URL(string: baseURL + "photos") {
            request(url: url, method: .get, body: nil, action: onAlbum, headers: headers)
        } else {
            Log.d("Invalid URL.")
        }
    }
    
    public func getAlbum(albumId: Int, onAlbum: @escaping (NetworkService.Handler)) {
        let headers = baseHeaders()
        if let url: URL = URL(string: baseURL + "albums/\(albumId)/photos") {
            request(url: url, method: .get, body: nil, action: onAlbum, headers: headers)
        } else {
            Log.d("Invalid URL.")
        }
    }
    
}
