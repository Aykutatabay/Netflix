//
//  CollectionViewTableViewCell.swift
//  Netflix
//
//  Created by Aykut ATABAY on 30.01.2023.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTap(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
    
}

class CollectionViewTableViewCell: UITableViewCell {
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    static let identifier = "CollectionViewTableViewCell"
    
    private var titles: [Title] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }

    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPaths: [IndexPath]) {
        
        let title = titles[indexPaths[0].row]
        DataPersistenceManager.shared.downloadTitleWith(model: title) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}




extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: titles[indexPath.row].poster_path ?? "")
        print("DEBUG: \(String(describing: titles[indexPath.row].poster_path))")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APICaller.shared.getMoview(with: titleName + "trailer") { [weak self] result  in
            DispatchQueue.main.async {
                switch result {
                case .success(let videoElement):
                    
                    guard let overview = self?.titles[indexPath.row].overview else {  return   }
                    
                    guard let strongSelf = self else { return }
                    
                    self?.delegate?.collectionViewTableViewCellDidTap(strongSelf, viewModel: TitlePreviewViewModel(title: titleName , youtubeView: videoElement, titleOverview: overview))
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {[weak self] _ in
            let downloadAction = UIAction(title: "xxxx", state: .off) {  _ in
                self?.downloadTitleAt(indexPaths: indexPaths)
            }
            return UIMenu(title: "", image: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}
