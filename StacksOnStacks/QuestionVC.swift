//
//  QuestionVC.swift
//  StacksOnStacks
//
//  Created by Ezekiel Abuhoff on 1/11/18.
//  Copyright © 2018 Ezekiel Abuhoff. All rights reserved.
//

import UIKit

class QuestionVC: UICollectionViewController {
    
    var items: [Item] = []
    
    override func viewDidLoad() {
        StackAPIClient.getQuestions { retrievedItems in
            OperationQueue.main.addOperation {
                self.items = retrievedItems
                self.collectionView?.reloadData()
            }
        }
    }
    
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
}

class QuestionCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}
