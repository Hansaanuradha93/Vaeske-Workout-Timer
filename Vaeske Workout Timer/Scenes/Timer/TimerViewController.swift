import UIKit

class TimerViewController: UIViewController {

    // MARK: Properties
    public class var storyboardName: String { return "Timer" }
    
    
    static func create() -> TimerViewController {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: TimerViewController.self)) as? TimerViewController
        return viewController!
    }
    
    var timer: Timer!
    var remainingTime: Int = 0
    
    
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
        setupView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    
    // MARK: IBActions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("Cancel")
        timer.invalidate()
    }
    
    
    @IBAction func startButtonTapped(_ sender: Any) {
        print("Timer Started")
        remainingTime = Int(timePicker.countDownDuration)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountdown), userInfo: nil, repeats: true)
    }
}


// MARK: - Methods
extension TimerViewController {
    
    @objc private func startCountdown() {
        if remainingTime > 0 {
            remainingTime -= 1
            print(remainingTime)
        } else {
            timer.invalidate()
        }
    }
    
    private func setupView() {
        
        startButtonContainer.layer.cornerRadius = startButtonContainer.frame.width / 2
        cancelButtonContainer.layer.cornerRadius = cancelButtonContainer.frame.width / 2
    }
}
