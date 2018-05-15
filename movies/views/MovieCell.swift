import UIKit
import Alamofire
import AlamofireImage

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieVotes: UILabel!
    @IBOutlet weak var movieReleasedDate: UILabel!
    
    var img: UIImage?
    
    func configureCell(imgPath: String, name: String, votes: Float, released: String){
        
        let path_for_image_download = "\(PATH_FOR_SMALL_IMAGE)"
        
        let requestString = path_for_image_download+imgPath

        self.movieName.text = name
        self.movieVotes.text = votes.description
        self.movieReleasedDate.text = released.description
        
        Alamofire.request(requestString).responseImage { response in
            if let img = response.result.value {
                self.movieImage.image = img
            }
        }
    }
}
