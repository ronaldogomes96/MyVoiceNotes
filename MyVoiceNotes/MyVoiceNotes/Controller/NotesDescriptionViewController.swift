//
//  NotesDescriptionViewController.swift
//  MyVoiceNotes
//
//  Created by Ronaldo Gomes on 20/10/20.
//

import UIKit

class NotesDescriptionViewController: UIViewController {

    @IBOutlet weak var userDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveNote(_ sender: Any) {
        let vc = SubmitViewController()
        vc.descriptionNote = userDescription.text
        navigationController?.pushViewController(vc, animated: true)
    }
}
