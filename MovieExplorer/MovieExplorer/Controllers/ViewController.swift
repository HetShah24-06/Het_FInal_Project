//
//  ViewController.swift
//  MovieExplorer
//
//  Created by Het Shah on 2025-04-16.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies: [Movie] = []
    let apiKey = "f5c735b2aefab6906ac80d771d096e08"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Popular Movies"
        tableView.delegate = self
        tableView.dataSource = self
        fetchPopularMovies()
    }
    @IBAction func goToSearch(_ sender: UIButton) {
            performSegue(withIdentifier: "showSearchScreen", sender: self)
        }


    

    func fetchPopularMovies() {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                let decoder = JSONDecoder()
                if let movieList = try? decoder.decode(MovieList.self, from: data) {
                    DispatchQueue.main.async {
                        self.movies = movieList.results
                        self.tableView.reloadData()
                    }
                }
            }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        cell.textLabel?.text = movie.title

        if let posterPath = movie.poster_path {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            DispatchQueue.global().async {
                if let url = imageURL, let data = try? Data(contentsOf: url) {
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
        if segue.identifier == "showDetail",
           let detailVC = segue.destination as? DetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            detailVC.movie = movies[indexPath.row]
        }
    }
}
