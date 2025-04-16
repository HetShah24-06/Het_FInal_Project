//
//  DetailViewController.swift
//  MovieExplorer
//
//  Created by Het Shah on 2025-04-16.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!

    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        guard let movie = movie else { return }

        titleLabel.text = movie.title
        dateLabel.text = "Release: \(movie.release_date)"
        overviewTextView.text = movie.overview

        if let posterPath = movie.poster_path {
            let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
            if let url = URL(string: urlString) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.movieImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
}

  
