//
//  Services.swift
//  swiftdi
//
//  Created by William Baker on 04/06/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

protocol DataFetcher {
    func getData() -> [Int]
}

struct DataFetcherImplementation: DataFetcher {
    func getData() -> [Int] {
        let upperLimit = Int.random(in: 4...20)
        return Array(1...upperLimit)
    }
}

struct DataFetcherMock: DataFetcher {
    func getData() -> [Int] {
        return [1, 2, 3, 4, 5, 6]
    }
}


protocol DataValidator {
    func pickValidItems(from array: [Int]) -> [Int]
}

struct DataValidatorImplementation: DataValidator {
    func pickValidItems(from array: [Int]) -> [Int] {
        return array.filter {
            $0.isMultiple(of: 2)
        }
    }
}

struct DataValidatorMock: DataValidator {
    func pickValidItems(from array: [Int]) -> [Int] {
        return array
    }
}
