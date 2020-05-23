import UIKit
import UserNotifications

class TimerViewController: UIViewController {

    // MARK: Properties
    public class var storyboardName: String { return "Timer" }
    
    
    static func create() -> TimerViewController {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: TimerViewController.self)) as? TimerViewController
        return viewController!
    }
    
    
    var timer: Timer!
    var remainingTime: Double = 0
    
    
    // MARK: IBOutlets
    @IBOutlet weak var timePickerContainerView: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var cancelButtonContainer: UIView!
    @IBOutlet weak var cancelButtonTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButtonContainer: UIView!
    @IBOutlet weak var startButtonTitleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var countDownLabel: UILabel!
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    // MARK: IBActions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        cancelButtonTapped()
        removePendingNotifications()
    }
    
    
    @IBAction func startButtonTapped(_ sender: Any) {
        startButtonTapped()

        scheduleNotifications(with: remainingTime)
    }
}


// MARK: - Methods
extension TimerViewController {
    
    @objc private func startCountdown() {
        
        if remainingTime > 0 {
            remainingTime -= 1
            countDownLabel.text = formatTime(from: remainingTime)
        } else {
            countDownLabel.text = formatTime(from: 0)
            timer.invalidate()
        }
    }
    
    
    private func scheduleNotifications(with timeInterval: TimeInterval) {

        let content = UNMutableNotificationContent()
        let requestIdentifier = "timerNotification"

        content.badge = 1
        content.title = "Vaeske Timer"
        content.body = "Lets do another 30 seconds workout"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: timeInterval, repeats: false)

        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in

            if let error = error {
                print(error.localizedDescription)
            }
            print("Notification Register Success")
        }
    }
    
    
    private func startButtonTapped() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountdown), userInfo: nil, repeats: true)
        remainingTime = timePicker.countDownDuration
        timePickerContainerView.isHidden = true
        startButton.isEnabled = false
        cancelButton.isEnabled = true
        countDownLabel.text = formatTime(from: remainingTime)
    }
    
    
    private func cancelButtonTapped() {
        
        remainingTime = 0
        timePickerContainerView.isHidden = false
        startButton.isEnabled = true
        cancelButton.isEnabled = false
        if let timer = timer {
            timer.invalidate()
        }
        countDownLabel.text = formatTime(from: remainingTime)
    }
    
    
    private func formatTime(from time: Double) -> String {
        
        var seconds = Int(time)
        
        let hours = seconds / 3600
        let minutes = seconds % 3600 / 60
        seconds = seconds % 3600 % 60
        
        var minutesString = "\(minutes)"
        var secondsString = "\(seconds)"
        
        if minutes < 10 {
            minutesString = "0\(minutes)"
        }
        
        if seconds < 10 {
           secondsString = "0\(seconds)"
        }
        
        var timeFormat = "\(hours):\(minutesString):\(secondsString)"
        
        if hours == 0 {
            timeFormat = "\(minutesString):\(secondsString)"
        } else if hours < 10 {
            timeFormat = "0\(hours):\(minutesString):\(secondsString)"
        }
        
        print("Hours: \(hours)\tMinues: \(minutes)\tSeconds: \(seconds)")
        
        return timeFormat
    }
    
    
    private func removePendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    
    private func setupView() {
        
        startButtonContainer.layer.cornerRadius = startButtonContainer.frame.width / 2
        cancelButtonContainer.layer.cornerRadius = cancelButtonContainer.frame.width / 2
        cancelButton.isEnabled = false
    }
}
