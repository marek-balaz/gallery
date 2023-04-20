//
//  MockNetworkService.swift
//  GalleryTests
//
//  Created by Marek Baláž on 20/04/2023.
//

import XCTest
@testable import Gallery

class MockNetworkService: BaseAPIProtocol {
    
    var baseURL: String = ""
    var photosResponse: (Error?, Int?, Data?)?
    var albumResponse: (Error?, Int?, Data?)?
    var downloadResponse: (Error?, Int?, Data?)?
    
    func getPhotos(onAlbum: @escaping (NetworkService.Handler)) {
        if let response = photosResponse {
            onAlbum(response.0, response.1, response.2)
        }
    }
        
    func getAlbum(albumId: Int, onAlbum: @escaping (NetworkService.Handler)) {
        if let response = albumResponse {
            onAlbum(response.0, response.1, response.2)
        }
    }
        
    func download(from url: URL, action: @escaping (NetworkService.Handler)) {
        if let response = downloadResponse {
            action(response.0, response.1, response.2)
        }
    }
    
}
