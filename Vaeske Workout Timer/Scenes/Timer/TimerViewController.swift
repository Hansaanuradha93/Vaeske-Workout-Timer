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
    var isFirstRound: Bool = false
    var isSecondRound: Bool = false
    let roundTime: Double = 30
    let transparency: CGFloat = 0.5
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()

    
    // MARK: IBOutlets
    @IBOutlet weak var timePickerContainerView: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var countDownContainer: UIView!
    @IBOutlet weak var cancelButtonContainer: UIView!
    @IBOutlet weak var cancelButtonTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButtonContainer: UIView!
    @IBOutlet weak var startButtonTitleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    // MARK: IBActions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        reset()
    }
    
    
    @IBAction func startButtonTapped(_ sender: Any) {
        startButtonTapped()
        scheduleNotifications(with: remainingTime, text: "Lets do another 30 seconds workout")
    }
}


// MARK: - Methods
extension TimerViewController {
    
    @objc private func handleTimer() {
        
        if remainingTime > 0 {
            remainingTime -= 1
            countDownLabel.text = formatTime(from: remainingTime)
        } else {
            
            if isFirstRound {
                
                addCircularBar(with: .systemPink)
                countDownLabel.textColor = .systemPink
                statusLabel.text = "WORK OUT"
                statusLabel.textColor = .systemPink
                
                startCountDown(with: roundTime)
                removePendingNotifications()
                scheduleNotifications(with: roundTime, text: "Take a 30 seconds Rest")

                isSecondRound = true
                isFirstRound.toggle()
                
                
            } else if isSecondRound {
                
                addCircularBar(with: .systemGreen)
                countDownLabel.textColor = .systemGreen
                statusLabel.text = "REST"
                statusLabel.textColor = .systemGreen
                
                startCountDown(with: roundTime)
                removePendingNotifications()
                scheduleNotifications(with: roundTime, text: "You have completed the workout successfully!")
                
                isSecondRound.toggle()
            } else {
                reset()
            }
            
        }
    }
    
    
    private func startCountDown(with time: Double) {
        
        remainingTime = time
        countDownLabel.text = formatTime(from: remainingTime)
        addCircularBarAnimation(with: remainingTime)
    }
    
    
    private func addCircularBar(with color: UIColor) {
        
        let center = countDownContainer.center
        let startAngle = -CGFloat.pi / 2
        let endAngle = (2 * CGFloat.pi) - CGFloat.pi / 2
        
        let circularPath = UIBezierPath(arcCenter: center, radius: countDownContainer.frame.width / 2 - 40, startAngle: startAngle, endAngle: endAngle, clockwise: true)
         
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 10
        countDownContainer.layer.addSublayer(trackLayer)
        
    
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 1

        countDownContainer.layer.addSublayer(shapeLayer)

    }
    
    
    private func removeCircularBarAnimation() {
        shapeLayer.removeAllAnimations()
    }
    
    
    private func addCircularBarAnimation(with duration: CFTimeInterval) {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = duration
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "circularWheel")
    }
    
    
    private func scheduleNotifications(with timeInterval: TimeInterval, text: String) {

        let content = UNMutableNotificationContent()
        let requestIdentifier = "timerNotification"

        content.badge = 1
        content.title = "Vaeske Timer"
        content.body = text
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
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        remainingTime = timePicker.countDownDuration
        addCircularBarAnimation(with: remainingTime)
        countDownLabel.text = formatTime(from: remainingTime)
        
        timePickerContainerView.isHidden = true
        countDownContainer.isHidden = false
        startButtonContainer.alpha = transparency
        cancelButtonContainer.alpha = 1

        startButton.isEnabled = false
        cancelButton.isEnabled = true

        isFirstRound = true
    }
    
    
    private func reset() {
        
        remainingTime = 0
        timePickerContainerView.isHidden = false
        countDownContainer.isHidden = true
        startButton.isEnabled = true
        cancelButton.isEnabled = false
        
        isFirstRound = false
        isSecondRound = false
        
        if let timer = timer {
            timer.invalidate()
        }
        countDownLabel.text = formatTime(from: remainingTime)
        
        addCircularBar(with: .systemIndigo)
        countDownLabel.textColor = .systemIndigo
        statusLabel.text = "WORK OUT"
        statusLabel.textColor = .systemIndigo
        cancelButtonContainer.alpha = transparency
        startButtonContainer.alpha = 1
        
        removePendingNotifications()
        removeCircularBarAnimation()
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
        
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")

        cancelButton.isEnabled = false
        cancelButtonContainer.alpha = transparency
        startButtonContainer.alpha = 1
        countDownContainer.isHidden = true

        addCircularBar(with: .systemIndigo)
        countDownLabel.textColor = .systemIndigo
        statusLabel.text = "WORK OUT"
        statusLabel.textColor = .systemIndigo
    }
}
