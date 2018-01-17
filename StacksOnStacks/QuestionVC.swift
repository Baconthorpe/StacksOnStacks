//
//  QuestionVC.swift
//  StacksOnStacks
//
//  Created by Ezekiel Abuhoff on 1/11/18.
//  Copyright © 2018 Ezekiel Abuhoff. All rights reserved.
//

import UIKit

class QuestionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Data Specifications
    let questionsToGet = 30
    
    // MARK: Information From Client
    var items: [StackAPIClient.Item] = []
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        StackAPIClient.getQuestions(count: questionsToGet) { retrievedItems in
            OperationQueue.main.addOperation {
                self.items = retrievedItems
                self.collectionView?.reloadData()
            }
        }
    }
    
    // MARK: Collection View Delegate
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionCell", for: indexPath) as? QuestionCell else { return UICollectionViewCell() }
        
        let question = items[indexPath.row]
        cell.titleLabel.text = question.title
        
        return cell
    }
    
    // MARK: Collection View Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 100);
    }
}

class QuestionCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}
