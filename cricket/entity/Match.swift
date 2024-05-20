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
    var bowlerPlayerIds: [String]?
    var bowlerTeamId: String?
    var batterPlayerIds: [String]?
    var batterTeamId: String?
    var title: String?
    var description: String?
}
