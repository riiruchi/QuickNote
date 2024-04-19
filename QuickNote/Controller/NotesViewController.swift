//
//  ViewController.swift
//  QuickNote
//
//  Created by Ruchira  on 17/04/24.
//
import UIKit

class NotesViewController: UIViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, QuickNote>! = nil
    private var notesCollectionView: UICollectionView! = nil
    private lazy var viewModel: NotesViewModel = NotesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
        configureCollectionView()
        configureDataSource()
        observeViewState()
        viewModel.fetchNotes()
    }

    private func observeViewState() {
            self.viewModel.onViewStateChange = { _ in
                self.onStateChange()
            }
            onStateChange()
    }

    private func onStateChange() {
        switch viewModel.viewState {
            case .empty:
                break
            case .ready(let status):
                switch status {
                case .getNotes:
                    updateCollectionView()
                }
                
            default: break
        }
    }
    
    @objc
    private func didTapAddButton() {
        let addNoteVC = AddNoteViewController()
        addNoteVC.delegate = self
        let navVC = UINavigationController(rootViewController: addNoteVC)
        navVC.navigationBar.prefersLargeTitles = true
        navVC.modalPresentationStyle = .formSheet
        present(navVC, animated: true, completion: nil)
    }

    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureCollectionView() {
        notesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        notesCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(notesCollectionView)
        notesCollectionView.delegate = self
    }
   
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, QuickNote> { cell, indexPath, note in
            var content = cell.defaultContentConfiguration()
            content.text = note.title
            content.textToSecondaryTextVerticalPadding = 8
            content.textProperties.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            content.textProperties.color = .label
            content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 16)
            content.secondaryTextProperties.color = .secondaryLabel
            content.secondaryTextProperties.numberOfLines = 1
            
            let bodyTextArray = note.body.components(separatedBy: " ")
            
            if (bodyTextArray.count > 8) {
                var bodyText = bodyTextArray[0...8].joined(separator: " ")
                bodyText.append("...")
                content.secondaryAttributedText = bodyText.getAttributedBodyText()
            } else {
                content.secondaryAttributedText = note.body.getAttributedBodyText()
            }
            
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, QuickNote>(collectionView: notesCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, note: QuickNote) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: note)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, QuickNote>()
        snapshot.appendSections([.main])
        
      
        snapshot.appendItems(viewModel.notes)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateCollectionView(isFromDelete: Bool = false) {
       
        var snapshot = dataSource.snapshot()
        if isFromDelete {
            snapshot.reconfigureItems(viewModel.notes)
        } else {
            snapshot.appendItems(viewModel.notes)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true) {
            self.notesCollectionView.reloadData()
            self.notesCollectionView.collectionViewLayout.invalidateLayout()
        }
        
    }
}

extension NotesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let note = self.dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        let noteVC = NoteDetailViewController()
        noteVC.note = note
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        true
    }
}

extension NotesViewController: AddNoteViewControllerDelegate {
    func didFinishAddingNote() {
        viewModel.fetchNotes()
        //updateCollectionView()
    }
}
