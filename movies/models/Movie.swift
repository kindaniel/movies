import Foundation
import Alamofire
import AlamofireImage
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class Movie {
    
    var popular: FeaturedVC?
    var top_rated: TopRatedVC?
    var titles: Array<String> = []
    var votes_average: Array<Float> = []
    var posters_path: Array<String> = []
    var releases_date: Array<String> = []
    var posters_image: Array<UIImage> = []
    var overviews: Array<String> = []
    
    var favorites: [FavoriteMovie] = []
    
    func addToFavorites(title: String, vote_average: Float, release_date: String, poster_path: String, overview: String){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let favoriteMovie = FavoriteMovie(context: managedContext)
        favoriteMovie.title = title
        favoriteMovie.vote_average = vote_average
        favoriteMovie.release_date = release_date
        favoriteMovie.poster_path = poster_path
        favoriteMovie.overview = overview
        do {
            try managedContext.save()
            print("O filme foi adicionado aos favoritos")
        } catch {
            debugPrint("Não foi possível salvar. \(error.localizedDescription)")
        }
    }
    
    func deleteFavoriteMovie(poster_path: String){
        guard let manegedContext = appDelegate?.persistentContainer.viewContext else { return }
        let predicate = NSPredicate(format: "poster_path == %@", poster_path)
        let fetchRequest = NSFetchRequest<FavoriteMovie>.init(entityName: "FavoriteMovie")
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        do {
            let result = try manegedContext.fetch(fetchRequest)
            if(result.count >= 1){
                for movie in result {
                    manegedContext.delete(movie)
                }
                do {
                    try manegedContext.save()
                } catch {
                    debugPrint("Não foi possível remover o filme. \(error.localizedDescription)")
                }
            }
        } catch {
            print(error)
        }
        
    }
    func isFavorite(poster_path: String) -> Bool {
        
        guard let manegedContext = appDelegate?.persistentContainer.viewContext else { return false }
        let predicate = NSPredicate(format: "poster_path == %@", poster_path)
        
        let fetchRequest = NSFetchRequest<FavoriteMovie>.init(entityName: "FavoriteMovie")
        fetchRequest.predicate = predicate
        do {
            let result = try manegedContext.fetch(fetchRequest)
            if(result.count >= 1){
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }

    }
    func getAll(category: String){
        let requestString = "\(BASE_URL)\(category)\(API_KEY)"
        Alamofire.request(requestString)
            .responseJSON { (response) in
                
                if let statusCode = response.response?.statusCode {
                    
                    if (statusCode == 200){
                        let result = response.result
                        if (result.value != nil) {
                            if let value = result.value as? Dictionary<String, AnyObject> {
                                if let results = value["results"] as? [Dictionary<String, AnyObject>] {
                                    self.storeResults(results: results, category: category)
                                }
                            }
                        }
                    }
                } else {
                    return
                }
        }
    }
    func storeResults(results: [Dictionary<String, AnyObject>], category: String){
        for data in results {
            let title = data["title"]
            self.titles.append(title as! String)
            
            let vote_average = data["vote_average"]
            self.votes_average.append(Float(vote_average as! NSNumber))
            let release_date = data["release_date"]
            self.releases_date.append(release_date as! String)
            let poster_path = data["poster_path"]
            self.posters_path.append(poster_path as! String)
            let overview = data["overview"]
            self.overviews.append(overview as! String)
            if(category == "popular"){
                self.popular?.tableView.reloadData()
                self.popular?.ActivityIndicator.stopAnimating()
            } else if (category == "top_rated"){
                self.top_rated?.tableView.reloadData()
            }
        }
        
    }
}

