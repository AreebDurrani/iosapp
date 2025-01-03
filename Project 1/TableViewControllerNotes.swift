import UIKit

class TableViewControllerNotes: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let addNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem = addNoteButton
        loadNotes()
    }

    var notes: [[String]] = [[]]

    override func numberOfSections(in tableView: UITableView) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = notes[indexPath.section][indexPath.row]
        contentConfiguration.image = UIImage(named: "note")
        cell.contentConfiguration = contentConfiguration
        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes[indexPath.section].remove(at: indexPath.row)
            saveNotes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @objc func addNote() {
        let alert = UIAlertController(title: "New Note", message: "Enter a note", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Type your note here"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            if let noteText = alert.textFields?.first?.text, !noteText.isEmpty {
                self.notes[0].append(noteText)
                self.saveNotes()
                let indexPath = IndexPath(row: self.notes[0].count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedNote = notes[fromIndexPath.section].remove(at: fromIndexPath.row)
        notes[to.section].insert(movedNote, at: to.row)
        saveNotes()
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Note", message: "Update your note", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.notes[indexPath.section][indexPath.row]
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let updatedText = alert.textFields?.first?.text, !updatedText.isEmpty {
                self.notes[indexPath.section][indexPath.row] = updatedText
                self.saveNotes()
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func saveNotes() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: "notes")
        }
    }

    func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "notes"),
           let savedNotes = try? JSONDecoder().decode([[String]].self, from: data) {
            notes = savedNotes
        } else {
            notes = [[]]
        }
    }
}

