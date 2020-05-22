import UIKit

class TimerViewController: UIViewController {

    // MARK: Properties
    public class var storyboardName: String { return "Timer" }
    
    
    static func create() -> TimerViewController {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: TimerViewController.self)) as? TimerViewController
        return viewController!
    }
    
    
    // MARK: IBOutlets
    @IBOutlet weak var timePickerContainerView: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var cancelButtonContainer: UIView!
    @IBOutlet weak var cancelButtonTitleLabel: UILabel!
    @IBOutlet weak var startButtonContainer: UIView!
    @IBOutlet weak var startButtonTitleLabel: UILabel!
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let seconds = timePicker.countDownDuration
        print(seconds)

    }
    
    
    // MARK: IBActions
    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func startButtonTapped(_ sender: Any) {
    }
}
