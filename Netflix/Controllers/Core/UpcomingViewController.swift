//
//  UpcomingViewController.swift
//  Netflix
//
//  Created by Aykut ATABAY on 30.01.2023.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var titles: [Title] = []
    
    let upcomingTable: UITableView = {
        
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        fetcUpcoming()
        view.addSubview(upcomingTable)
        
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    func fetcUpcoming() {
        APICaller.shared.getUpcomingMovies {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    self?.titles = titles
                    DispatchQueue.main.async {
                        self?.upcomingTable.reloadData()
                    }
                case .failure(let error):
                    print("DEBUG:", error.localizedDescription)
                }
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: TitleViewModel(titleName: (self.titles[indexPath.row].original_name ?? self.titles[indexPath.row].original_title) ?? "Unknown Title", posterUrl: self.titles[indexPath.row].poster_path ?? "Unknown"))
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
