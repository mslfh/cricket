//
//  Match.swift
//  cricket
//
//  Created by mobiledev on 17/5/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct Match : Codable
{
    @DocumentID var documentID: String?
    
    var title: String?
    var description: String?
    
    var bowlerTeamId: String?
    var bowlerTeamName: String?
    var bowlerPlayers: [Player]?
    
    var batterTeamId: String?
    var batterTeamName: String?
    var batterPlayers: [Player]?
}
