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
//    var bowlerPlayers: [Player]?
//    var bowlerTeamName: String?
//    
//    var batterPlayers: [Player]?
//    var batterTeamName: String?
    
    var title: String?
    var description: String?
}
