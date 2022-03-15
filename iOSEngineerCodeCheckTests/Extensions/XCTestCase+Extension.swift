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

    func nextValues<P: Publisher>(of publisher: P, count: Int, timeout: TimeInterval = 3)
        async throws
        -> [P.Output]
    {
        try await withThrowingTaskGroup(of: [P.Output].self) { group in
            group.addTask {
                var values: [P.Output] = []
                for try await value in publisher.values {
                    values.append(value)
                    if values.count >= count {
                        return values
                    }
                }
                throw "publisher is unexpectedly completed"
            }

            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                print("sleep finished")
                try Task.checkCancellation()
                throw TimeoutError()
            }

            guard let next = try await group.next() else {
                throw "unexpected nil result in noNextValue"
            }
            group.cancelAll()
            print("next")
            return next
        }
    }

    func noNextValue<P: Publisher>(of publisher: P, waitTime: TimeInterval = 0.1) async throws
        -> Bool
    {
        do {
            let _ = try await self.nextValues(of: publisher, count: 1, timeout: waitTime)
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
