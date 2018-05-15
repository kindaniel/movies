import UIKit
import Alamofire

class FeaturedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    var movie: Movie!
    var movieTitle: String?
    var movieVotes: Float?
    var movieReleasedDate: String?
    var movieImgPath: String?
    var movieOverview: String?
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.ActivityIndicator.startAnimating()
        requestFeaturedMovies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.movie.titles.count != 0){
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieCell
            {
                let movieTitle = self.movie.titles[indexPath.row]
                let movieVotes = self.movie.votes_average[indexPath.row]
                let movieReleasedDate = self.movie.releases_date[indexPath.row]
                let movieImgPath = self.movie.posters_path[indexPath.row]
                cell.configureCell(imgPath: movieImgPath, name: movieTitle, votes: movieVotes, released: movieReleasedDate)
                return cell
            }
        }
        let cellNormal = UITableViewCell(style: .default, reuseIdentifier: nil)
        return cellNormal
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.movie.titles.count == 0){
            return
        }
        self.movieTitle = self.movie.titles[indexPath.row]
        self.movieVotes = self.movie.votes_average[indexPath.row]
        self.movieReleasedDate = self.movie.releases_date[indexPath.row]
        self.movieImgPath = self.movie.posters_path[indexPath.row]
        self.movieOverview = self.movie.overviews[indexPath.row] 
        self.performSegue(withIdentifier: "FeaturedDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FeaturedDetail"){
            if let detailsVC = segue.destination as? DetailsVC {
                detailsVC.mTitle = self.movieTitle
                detailsVC.mReleased = self.movieReleasedDate
                detailsVC.mVote = self.movieVotes
                detailsVC.mImgPath = self.movieImgPath
                detailsVC.mPreview = self.movieOverview
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func requestFeaturedMovies(){
        self.movie = Movie()
        self.movie.popular = self
        movie.getAll(category: "popular")
    }
}
