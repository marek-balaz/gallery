//
//  GalleryCollectionViewModelUnitTests.swift
//  GalleryTests
//
//  Created by Marek Baláž on 20/04/2023.
//

import XCTest
@testable import Gallery

class GalleryCollectionViewModelTests: XCTestCase {

    var viewModel: GalleryCollectionViewModel!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = GalleryCollectionViewModel(networkService: mockNetworkService)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testGetPhotos() {
        let expectation = XCTestExpectation(description: "Should receive album data")
        let delegate = MockDelegate(expectation: expectation)
        let album = ["root_array": [
            [ "albumId": 1, "id": 1, "title": "accusamus beatae ad facilis cum similique qui sunt", "url": "https://via.placeholder.com/600/92c952", "thumbnailUrl": "https://via.placeholder.com/150/92c952" ],
            [ "albumId": 1, "id": 2, "title": "reprehenderit est deserunt velit ipsam", "url": "https://via.placeholder.com/600/771796",  "thumbnailUrl": "https://via.placeholder.com/150/771796" ],
            [ "albumId": 1, "id": 3, "title": "officia porro iure quia iusto qui ipsa ut modi", "url": "https://via.placeholder.com/600/24f355", "thumbnailUrl": "https://via.placeholder.com/150/24f355" ]
        ]]
        
        do {
            let albumData = try JSONSerialization.data(withJSONObject: album, options: [])
            mockNetworkService.photosResponse = (nil, 200, albumData)
            viewModel.delegate = delegate
            viewModel.getPhotos()

            wait(for: [expectation], timeout: 10.0)

            XCTAssertNotNil(viewModel.album, "Album should not be nil")
            XCTAssertTrue(viewModel.numberOfPhotos() > 0, "Number of photos should be greater than 0")
        } catch {
            XCTAssertThrowsError("Could not parse Album to Data.")
        }
    }

    func testFetchLocalImages() {

        viewModel.album = Album(fromJson: ["root_array": [
            [ "albumId": 1, "id": 1, "title": "accusamus beatae ad facilis cum similique qui sunt", "url": "https://via.placeholder.com/600/92c952", "thumbnailUrl": "https://via.placeholder.com/150/92c952" ],
            [ "albumId": 1, "id": 2, "title": "reprehenderit est deserunt velit ipsam", "url": "https://via.placeholder.com/600/771796",  "thumbnailUrl": "https://via.placeholder.com/150/771796" ],
            [ "albumId": 1, "id": 3, "title": "officia porro iure quia iusto qui ipsa ut modi", "url": "https://via.placeholder.com/600/24f355", "thumbnailUrl": "https://via.placeholder.com/150/24f355" ]
        ]])

        viewModel.fetchLocalImages(for: viewModel.album)

        XCTAssertNotEqual(viewModel.album?.photos?[0].thumbnail, nil)
        XCTAssertNotEqual(viewModel.album?.photos?[1].thumbnail, nil)
    }

    func testNumberOfPhotos() {
        viewModel.album = Album(fromJson: ["root_array": [
            [ "albumId": 1, "id": 1, "title": "accusamus beatae ad facilis cum similique qui sunt", "url": "https://via.placeholder.com/600/92c952", "thumbnailUrl": "https://via.placeholder.com/150/92c952" ],
            [ "albumId": 1, "id": 2, "title": "reprehenderit est deserunt velit ipsam", "url": "https://via.placeholder.com/600/771796",  "thumbnailUrl": "https://via.placeholder.com/150/771796" ],
            [ "albumId": 1, "id": 3, "title": "officia porro iure quia iusto qui ipsa ut modi", "url": "https://via.placeholder.com/600/24f355", "thumbnailUrl": "https://via.placeholder.com/150/24f355" ]
        ]])

        XCTAssertEqual(viewModel.numberOfPhotos(), 3)
    }

    func testSetSelectedPhoto() {
        viewModel.album = Album(fromJson: ["root_array": [
            [ "albumId": 1, "id": 1, "title": "accusamus beatae ad facilis cum similique qui sunt", "url": "https://via.placeholder.com/600/92c952", "thumbnailUrl": "https://via.placeholder.com/150/92c952" ],
            [ "albumId": 1, "id": 2, "title": "reprehenderit est deserunt velit ipsam", "url": "https://via.placeholder.com/600/771796",  "thumbnailUrl": "https://via.placeholder.com/150/771796" ],
            [ "albumId": 1, "id": 3, "title": "officia porro iure quia iusto qui ipsa ut modi", "url": "https://via.placeholder.com/600/24f355", "thumbnailUrl": "https://via.placeholder.com/150/24f355" ]
        ]])

        viewModel.setSelectedPhoto(at: 1)

        XCTAssertEqual(viewModel.selectedPhoto?.thumbnailUrl, "https://via.placeholder.com/150/771796")
    }

}


