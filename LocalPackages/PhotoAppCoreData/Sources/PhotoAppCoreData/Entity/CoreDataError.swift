//
//  CoreDataError.swift
//  PhotoAppCoreData
//
//  Created by 김기림 on 2/4/24.
//

import Foundation

public enum CoreDataError: Error, CustomDebugStringConvertible {
    
    case fetchFailure(String)
    case savingFailure
    case removeFailure
    case updateFailure
    
    public var debugDescription: String {
        switch self {
            case .fetchFailure(let detail):         return "Entity Fetch 실패 - \(detail)"
            case .savingFailure:                    return "저장 실패"
            case .removeFailure:                    return "삭제 실패"
            case .updateFailure:                    return "업데이트 실패"
        }
    }
    
}
