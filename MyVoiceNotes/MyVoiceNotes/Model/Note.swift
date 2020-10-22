//
//  Note.swift
//  MyVoiceNotes
//
//  Created by Ronaldo Gomes on 22/10/20.
//

import Foundation
import CoreData

class Note: NSManagedObject {
    
    static func fetchAllNotes(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
        request.sortDescriptors = [sort]
        guard let note = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return note
    }
    
    static func saveNotes(descriptionNote: String) {
        let note = Note(context: AppDelegate.viewContext)
        note.descriptionNote = descriptionNote
        note.audio = RecordNoteViewController.getRecordURL()
        note.startDate = NSDate.now
        try? AppDelegate.viewContext.save()
    }
}
