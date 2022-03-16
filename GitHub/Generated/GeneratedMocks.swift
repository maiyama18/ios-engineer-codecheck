///
/// @Generated by Mockolo
///



import Foundation


public class NetworkingMock: Networking {
    public init() { }


    public private(set) var dataCallCount = 0
    public var dataArgValues = [(URLRequest, URLSessionTaskDelegate?)]()
    public var dataHandler: ((URLRequest, URLSessionTaskDelegate?) async throws -> (
        Data, URLResponse
    ))?
    public func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (
        Data, URLResponse
    ) {
        dataCallCount += 1
        dataArgValues.append((request, delegate))
        if let dataHandler = dataHandler {
            return try await dataHandler(request, delegate)
        }
        fatalError("dataHandler returns can't have a default value thus its handler must be set")
    }
}

public class GitHubClientProtocolMock: GitHubClientProtocol {
    public init() { }


    public private(set) var searchCallCount = 0
    public var searchArgValues = [String]()
    public var searchHandler: ((String) async throws -> ([Repository]))?
    public func search(query: String) async throws -> [Repository] {
        searchCallCount += 1
        searchArgValues.append(query)
        if let searchHandler = searchHandler {
            return try await searchHandler(query)
        }
        return [Repository]()
    }
}
