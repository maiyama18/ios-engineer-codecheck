//
//  XCTestCase+Extension.swift
//  iOSEngineerCodeCheckTests
//
//  Created by maiyama on 2022/03/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import XCTest

struct TimeoutError: Error {}

extension XCTestCase {
    func asyncTest(operation: @escaping () -> Void, assertions: () async throws -> Void)
        async throws
    {
        async let assertionsResult: Void = assertions()
        async let operationResult = Task { operation() }

        let _ = try await (assertionsResult, operationResult)
    }

    func awaitValue<S: AsyncSequence>(of stream: S, timeout: TimeInterval = 3) async throws
        -> S.Element
    {
        try await withThrowingTaskGroup(of: S.Element.self) { group in
            group.addTask {
                for try await value in stream.prefix(1) {
                    return value
                }
                throw "stream is unexpectedly completed"
            }

            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                try Task.checkCancellation()
                throw TimeoutError()
            }

            guard let next = try await group.next() else {
                throw "unexpected nil result in awaitValue"
            }
            group.cancelAll()
            return next
        }
    }

    func noValue<S: AsyncSequence>(of stream: S, waitTime: TimeInterval = 0.1) async throws -> Bool
    {
        do {
            let _ = try await awaitValue(of: stream, timeout: waitTime)
            return false
        } catch {
            return error is TimeoutError
        }
    }
}

// swift-format-ignore: AlwaysUseLowerCamelCase
func XCTAssertAwaitEqual<T: Equatable>(
    _ expression1: @autoclosure () async throws -> T, _ expression2: @autoclosure () throws -> T,
    _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line
) async throws {
    let value = try await expression1()
    XCTAssertEqual(value, try expression2(), message(), file: file, line: line)
}

// swift-format-ignore: AlwaysUseLowerCamelCase
func XCTAssertAwaitTrue(
    _ expression: @autoclosure () async throws -> Bool,
    _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line
) async throws {
    let value = try await expression()
    XCTAssertEqual(value, true, message(), file: file, line: line)
}
