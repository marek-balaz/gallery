//
//  MockDelegate.swift
//  GalleryTests
//
//  Created by Marek Baláž on 20/04/2023.
//

import XCTest
@testable import Gallery

class MockDelegate: GalleryCollectionViewModelDelegate {

    let expectation: XCTestExpectation
    var albumDataReceived = false

    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }

    func didReceiveAlbumData() {
        albumDataReceived = true
        expectation.fulfill()
    }

    func shouldShowPhotoDetail() {
        
    }

}
