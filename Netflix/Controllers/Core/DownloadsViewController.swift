//
//  DownloadsViewController.swift
//  Netflix
//
//  Created by Aykut ATABAY on 30.01.2023.
//

import UIKit

class DownloadsViewController: UIViewController {

    private var titles: [TitleItem] = []
    
    let downloadedTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(downloadedTable)
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }
    
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchDataFromDatabase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                self?.downloadedTable.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func deleteDataFromDatabase() {
        
    }

}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: TitleViewModel(titleName: (self.titles[indexPath.row].original_name ?? self.titles[indexPath.row].original_title) ?? "Unknown Title", posterUrl: self.titles[indexPath.row].poster_path ?? "Unknown"))
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete :
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { result in
                switch result {
                case .success(()):
                    print("Successfully deleted from database !")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        let titleName = title.original_title ?? title.original_name ?? ""
        let titleOverview = title.overview ?? ""
        
        APICaller.shared.getMoview(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }

            case .failure(let error):
                print(error.localizedDescription    )
            }
        }
    }
    
}
