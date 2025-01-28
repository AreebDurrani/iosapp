//
//  ViewControllerNotes.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/16/25.
//

import UIKit
import CoreData

class ViewControllerNotes: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var addView: UIView!
    
    @IBOutlet weak var addViewTextView: UITextView!
    @IBOutlet weak var editViewTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    var notes: [Note] = [] // CoreData will manage this array
    var selectedNote : Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewLayout()
        disableEditView()
        disableAddView()
        setUpOverlayView()
        navigationItem.titleView = createUsernameLabel().customView
        if let navigationController = self.navigationController {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground() // Prevents transparency
            appearance.backgroundColor = UIColor.black // Set your desired background color
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        //let addNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        let addNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newNote))

        //addNoteButton.tintColor = UIColor(red: 221, green: 232, blue: 10, alpha: 1)
        self.navigationItem.leftBarButtonItem = addNoteButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 221/255, green: 232/255, blue: 10/255, alpha: 1)
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
        //print(notes.count)
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
        selectedNote = note
        /*let alert = UIAlertController(title: "Edit Note", message: "Update your note", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = note.content
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let updatedText = alert.textFields?.first?.text, !updatedText.isEmpty {
                self.updateNote(note: note, with: updatedText)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)*/
        enableEditView()
        setUpEditView(noteContent : note.content!)
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
            notes = try context.fetch(fetchRequest).reversed()
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
            //notes.append(newNote, at)
            notes.insert(newNote, at: 0)
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
    @IBAction func logoutPressed(_ sender: Any) {
        handleLogout()
    }
    
}

extension ViewControllerNotes {
    func handleLogout() {
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    func enableEditView() {
        editView.isHidden = false
        overlayView.isHidden = false
    }
    
    func setUpEditView(noteContent : String) {
        editViewTextView.text = noteContent
        editView.layer.cornerRadius = 10
    }
    
    func disableEditView(){
        editView.isHidden = true
        overlayView.isHidden = true
        selectedNote = nil
    }
    
    func enableAddView() {
        addView.isHidden = false
        overlayView.isHidden = false
    }
    
    func setUpaddView() {
        addView.layer.cornerRadius = 10
    }
    
    func disableAddView() {
        addView.isHidden = true
        overlayView.isHidden = true
    }
    
    func setUpOverlayView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayViewTapped))
        overlayView.isUserInteractionEnabled = true // Ensure the view can interact
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc func overlayViewTapped(_ sender: UITapGestureRecognizer) {
        if editView.isHidden == false{
            let updatedContent = editViewTextView.text!
            self.updateNote(note: selectedNote!, with: updatedContent)
            self.disableEditView()
        }
        if addView.isHidden == false{
            self.saveNote(content: addViewTextView.text!)
            self.disableAddView()
        }
    }
    
    @objc func newNote(){
        setUpaddView()
        enableAddView()
    }
    
    
}
