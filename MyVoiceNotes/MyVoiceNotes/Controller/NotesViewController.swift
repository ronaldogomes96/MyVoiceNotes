//
//  NotesViewController.swift
//  MyVoiceNotes
//
//  Created by Ronaldo Gomes on 20/10/20.
//

import UIKit

class NotesViewController: UITableViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    var note = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotes()
    }
    
    func loadNotes() {
        note = Note.fetchAllNotes()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return note.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = note[indexPath.row].descriptionNote
        
        let data = DateFormatter().string(from: note[indexPath.row].startDate!)
        cell.detailTextLabel?.text = data
        
        return cell
    }
    
    @IBAction func addNote(_ sender: Any) {
        let vc = RecordNoteViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
