//
//  MediaCoverageRepository.swift
//  PicScroll
//
//  Created by Dhruv Govani on 16/04/24.
//

import Foundation
import Combine

class MediaCoverageRepository {
    
    private let baseURL = "https://acharyaprashant.org/api/v2/content/misc/media-coverages"
    
    var cancellables: Set<AnyCancellable> = []
    
    /// Fetch Media Coverages From Endpoint
    func fetchMediaCoverages(limit: Int) -> AnyPublisher<[MediaCoverageElement], Error> {
        guard let url = URL(string: "\(baseURL)?limit=\(limit)") else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                .eraseToAnyPublisher()
        }
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        let session = URLSession(configuration: config)
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [MediaCoverageElement].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
