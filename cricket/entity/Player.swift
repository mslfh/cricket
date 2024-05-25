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

public struct Player : Codable, Equatable
{
    @DocumentID var documentID:String?
    var name:String
    var description:String?
    var image64encode:String?
    var teamId:String?
}
