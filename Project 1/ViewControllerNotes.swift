//
//  ViewControllerNotes.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/16/25.
//

import UIKit
import CoreData

class ViewControllerNotes: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var notes: [Note] = [] // CoreData will manage this array

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        /*let addButton = UIButton(type: .custom)
            addButton.setImage(UIImage(systemName: "plus"), for: .normal) // Set an image for the button
            addButton.backgroundColor = UIColor(red: 221/255, green: 232/255, blue: 10/255, alpha: 1) // Background color
            addButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30) // Adjust size if needed
            addButton.layer.cornerRadius = 5 // Optional: Rounded corners
            addButton.addTarget(self, action: #selector(addNote), for: .touchUpInside)

            // Create a UIBarButtonItem with the custom UIButton
            let addNoteButton = UIBarButtonItem(customView: addButton)
            self.navigationItem.leftBarButtonItem = addNoteButton*/
        let addNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        //addNoteButton.tintColor = UIColor(red: 221, green: 232, blue: 10, alpha: 1)
        self.navigationItem.leftBarButtonItem = addNoteButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 221, green: 232, blue: 10, alpha: 1)
        fetchNotes()
    }

    private func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 100)
        layout.minimumLineSpacing = 20
        collectionView.collectionViewLayout = layout
    }

    // MARK: - Collection View Data Source

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(notes.count)
        return notes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "notesCell", for: indexPath) as! NotesCollectionViewCell
        /*var contentConfiguration = UIListContentConfiguration.cell()
        contentConfiguration.text = notes[indexPath.row].content
        contentConfiguration.image = UIImage(named: "note")
        cell.contentConfiguration = contentConfiguration*/
        cell.noteText.text = notes[indexPath.row].content

        // Add a long press gesture recognizer for deletion
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        cell.addGestureRecognizer(longPressRecognizer)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let point = gesture.location(in: collectionView)

        if let indexPath = collectionView.indexPathForItem(at: point) {
            let alert = UIAlertController(title: "Delete Note", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.deleteNote(at: indexPath)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - CoreData Operations

    func fetchNotes() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            notes = try context.fetch(fetchRequest)
            collectionView.reloadData()
        } catch {
            print("Error fetching notes: \(error)")
        }
    }

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

    func saveNote(content: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let newNote = Note(context: context)
        newNote.content = content

        do {
            try context.save()
            notes.append(newNote)
            collectionView.reloadData()
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
            collectionView.reloadData()
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
            collectionView.deleteItems(at: [indexPath])
        } catch {
            print("Error deleting note: \(error)")
        }
    }

}
