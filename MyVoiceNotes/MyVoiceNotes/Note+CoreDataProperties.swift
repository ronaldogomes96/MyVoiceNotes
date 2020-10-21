//
//  Note+CoreDataProperties.swift
//  MyVoiceNotes
//
//  Created by Ronaldo Gomes on 20/10/20.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var descriptionNote: String?
    @NSManaged public var audio: URL?
    @NSManaged public var startDate: Date?

}

extension Note : Identifiable {

}
