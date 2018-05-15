import UIKit
import Alamofire
import AlamofireImage

class FavoriteCell: UITableViewCell {
    
    var img: UIImage?
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieVotes: UILabel!
    @IBOutlet weak var movieReleasedDate: UILabel!

    func configureCell(favorite: FavoriteMovie){
        
        let path_for_image_download = "http://image.tmdb.org/t/p/w92//"
        
        let requestString = path_for_image_download+favorite.poster_path!
        
        print(requestString)
        
        self.movieName.text = favorite.title
        self.movieVotes.text = favorite.vote_average.description
        self.movieReleasedDate.text = favorite.release_date
        
        Alamofire.request(requestString).responseImage { response in
            if let img = response.result.value {
                self.movieImage.image = img
            }
        }
    }
}


