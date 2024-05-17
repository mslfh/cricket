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

public struct Team : Codable
{
    @DocumentID var documentID:String?
    var teamName:String
    var playerIds : [String]
    var description:String
    var image64encode:String
}
