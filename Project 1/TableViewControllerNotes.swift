import UIKit
import CoreData

class TableViewControllerNotes: UITableViewController {

    var notes: [Note] = [] // CoreData will manage this array

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.leftBarButtonItem = addNoteButton
        
        fetchNotes()
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // CoreData doesn't require multiple sections for now
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = notes[indexPath.row].content
        contentConfiguration.image = UIImage(named: "note")
        cell.contentConfiguration = contentConfiguration
        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(at: indexPath)
        }
    }

    // MARK: - Adding Notes

    @objc func addNote() {
        let alert = UIAlertController(title: "New Note", message: "Enter a note", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Type your note here"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            if let noteText = alert.textFields?.first?.text, !noteText.isEmpty {
                self.saveNote(content: noteText)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Editing Notes

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        let alert = UIAlertController(title: "Edit Note", message: "Update your note", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = note.content
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let updatedText = alert.textFields?.first?.text, !updatedText.isEmpty {
                self.updateNote(note: note, with: updatedText)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - CoreData Operations

    func fetchNotes() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            notes = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching notes: \(error)")
        }
    }

    func saveNote(content: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let newNote = Note(context: context)
        newNote.content = content
        
        do {
            try context.save()
            notes.append(newNote)
            tableView.reloadData()
        } catch {
            print("Error saving note: \(error)")
        }
    }

    func updateNote(note: Note, with content: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        note.content = content
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Error updating note: \(error)")
        }
    }

    func deleteNote(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let noteToDelete = notes[indexPath.row]
        context.delete(noteToDelete)
        do {
            try context.save()
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
            print("Error deleting note: \(error)")
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        let vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewControllerLogin")
        self.navigationController?.setViewControllers([vc], animated:true)
    }
}

