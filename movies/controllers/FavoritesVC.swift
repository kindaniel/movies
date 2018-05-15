import UIKit
import CoreData

class FavoritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favorites: [FavoriteMovie] = []
    
    var movie: Movie!
    var movieTitle: String?
    var movieVotes: Float?
    var movieReleasedDate: String?
    var movieImgPath: String?
    var movieOverview: String?
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetch()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.movieTitle = favorites[indexPath.row].title
        self.movieVotes = favorites[indexPath.row].vote_average
        self.movieReleasedDate = favorites[indexPath.row].release_date
        self.movieImgPath = favorites[indexPath.row].poster_path
        self.movieOverview = favorites[indexPath.row].overview
        self.performSegue(withIdentifier: "FavoriteDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FavoriteDetail"){
            if let detailsVC = segue.destination as? DetailsVC {
                detailsVC.mTitle = self.movieTitle
                detailsVC.mReleased = self.movieReleasedDate
                detailsVC.mVote = self.movieVotes
                detailsVC.mImgPath = self.movieImgPath
                detailsVC.mPreview = self.movieOverview
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.favorites.count != 0){
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell
            {
                let favorite = favorites[indexPath.row]
                cell.configureCell(favorite: favorite)
                return cell
            }
        }
        let cellNormal = UITableViewCell(style: .default, reuseIdentifier: nil)
        return cellNormal
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    
}

extension FavoritesVC {
    func fetch(){
        guard let manegedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
        do {
            favorites = try manegedContext.fetch(fetchRequest)
        } catch {
            debugPrint("Não foi possível buscar as informações. \(error.localizedDescription)")
        }
    }
    

}
