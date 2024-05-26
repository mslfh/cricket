//
//  HistoryBall.swift
//  cricket
//
//  Created by mobiledev on 26/5/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct HistoryBall : Codable
{
    @DocumentID var documentID: String?
    
    var matchTitle: String?
    
    var batterTeam: String?
    var bowlerTeam: String?
    
    var finalScore: String?
    
    var balls: [Ball]?
}
