//
//  SearchViewController.swift
//  MovieExplorer
//
//  Created by Het Shah on 2025-04-16.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    let apiKey = "f5c735b2aefab6906ac80d771d096e08"
    var searchResults: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        title = "Search Movies"
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query)"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(MovieList.self, from: data) {
                    DispatchQueue.main.async {
                        self.searchResults = result.results
                        self.tableView.reloadData()
                    }
                }
            }
        }
        task.resume()
        searchBar.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        cell.textLabel?.text = movie.title

        if let poster = movie.poster_path {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL!) {
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: data)
                        cell.setNeedsLayout()
                    }
                }
            }
        }

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchDetail",
           let detailVC = segue.destination as? DetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            detailVC.movie = searchResults[indexPath.row]
        }
    }
}
