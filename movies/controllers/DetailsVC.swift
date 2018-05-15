import UIKit
import Alamofire
import AlamofireImage

class DetailsVC: UIViewController {
    
    //outlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieVoteAverage: UILabel!
    @IBOutlet weak var movieReleasedDate: UILabel!
    @IBOutlet weak var moviePreview: UITextView!

    @IBOutlet weak var addToFavoritesBtn: UIButton!
    //
    
    var mTitle: String?
    var mVote: Float?
    var mReleased: String?
    var mPreview: String?
    var mImgPath: String?
    
    var isFavorite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosterImage(imgPath: mImgPath!)
        self.movieTitle.text = mTitle
        self.movieVoteAverage.text = mVote?.description
        self.movieReleasedDate.text = "Released: \(mReleased!)"
        self.moviePreview.text = mPreview
        self.checkIfAreFavorite()
    }
    func checkIfAreFavorite(){
        if(self.isFavorite == true){
            addToFavoritesBtn.backgroundColor = UIColor.red
            addToFavoritesBtn.setTitle("Remove from favorites", for: .normal)
        }
    }
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func getPosterImage(imgPath: String){
        let path_for_image_download = "\(PATH_FOR_LARGE_IMAGE)"
        
        let requestString = path_for_image_download+imgPath
        
        let movie = Movie()
        self.isFavorite = movie.isFavorite(poster_path: imgPath)
        
        Alamofire.request(requestString).responseImage { response in
            if let img = response.result.value {
                self.imgView.image = img
            }
        }
        
    }
    @IBAction func favoriteBtnWasPressed(_ sender: Any) {
        let movie = Movie()
        if (self.isFavorite == true) {
            movie.deleteFavoriteMovie(poster_path: self.mImgPath!)
            dismiss(animated: true, completion: nil)
        } else {
            movie.addToFavorites(title: self.mTitle!, vote_average: self.mVote!, release_date: self.mReleased!, poster_path: self.mImgPath!, overview: self.mPreview!)
            self.isFavorite = true
            self.checkIfAreFavorite()
        }
    }
    
}

