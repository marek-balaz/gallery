//
//  Debouncer.swift
//  Gallery
//
//  Created by Marek Baláž on 21/04/2023.
//

import Foundation

class Debouncer {
    private let delay: TimeInterval
    private var timer: DispatchSourceTimer?
    
    init(delay: TimeInterval) {
        self.delay = delay
    }
    
    func debounce(action: @escaping (() -> Void)) {
        timer?.cancel()
        timer = nil
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now() + delay)
        timer?.setEventHandler(handler: {
            action()
        })
        timer?.resume()
    }
}
