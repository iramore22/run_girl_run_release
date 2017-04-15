

import UIKit
import SAConfettiView
import UserNotifications


class RunController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    var smallTimer: UILabel?
    var bigTimer: UILabel?
    var smallTimerStage: UILabel?
    var bigTimerStage: UILabel?
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    var iMinSessions = 3
    var iTryAgainSessions = 6
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var muteLabel: UILabel!
    
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var runner: UIImageView!
    
    @IBOutlet weak var runCircles: RunCircles!
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var image: UIImageView!
    var confettiView: SAConfettiView!
    
    
    var timerSmall = Timer()
    var confTimer = Timer()
    var train: Train = Train_data.trains[((ShareData.sharedInstance.userData?.completedTrainsDates?.count)!+1)]!
    var currentStage = 0
    var counter: Int = 0
    var counterBig: Int = 0
    var index:Int = 0
    var screenWidth:CGFloat = 0
    var runningMan:[UIImage] = [UIImage(named: "rrrr1")!, UIImage(named: "rrrr2")!]
    var walkingMan:[UIImage] = [UIImage(named: "rrrr3")!, UIImage(named: "rrrr4")!]
    var isStarted: Bool = false
    var imagePos: CGFloat = 0
    var isRunning: Bool = true
    var trainingCompeleted = false
    var sticker: UIImageView?
    var firstStart: Bool = true
    // var confTimer: Int = 0
    var cropRunnerCounter = 1
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func loadTrain() {
        counter = train.temp[0]
        counter *= 100
        runCircles.maxValueSmall = counter
        let value = train.temp.reduce(0, +)
        runCircles.maxValueBig = value
        counterBig = value
        let firstImage: CGSize = train.trainMenu[0].size
        imagePos = firstImage.width
    }
    
    
    func startButtonPressed() {
        if trainingCompeleted
        {
            dismiss(animated: true, completion: nil)
        }
        if(!isStarted){
            if(firstStart){
                firstStart = false
                var timeStr: NSString
                if(Float(train.temp[0]).truncatingRemainder(dividingBy: 60) == 0){
                    timeStr = NSString(format:"%.1d", (train.temp[index])/60)
                } else{
                    timeStr = NSString(format:"%.1f", (Float(train.temp[index]))/60)
                }
                let audio = "run\(timeStr).mp3"
                SKTAudio.sharedInstance().playSoundEffect(audio)
            }
            timerSmall.invalidate()
            timerSmall = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(RunController.timerActionSmall), userInfo:nil ,   repeats: true)
            startButton.setTitle("PAUSE", for: UIControlState())
            //self.startButton.setImage(UIImage(named: "pause"), for: UIControlState())
            if(isRunning){
                self.runner.animationImages = runningMan
            } else{
                self.runner.animationImages = walkingMan
            }
            self.runner.animationDuration = 0.5
            self.runner.startAnimating()
            isStarted = true
            muteLabel.isHidden = false
            muteLabel.alpha = 1.0
            UIView.animate(withDuration: 2, delay: 3, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {self.muteLabel.alpha = 0.0}, completion: { finished in self.muteLabel.isHidden = true})
            
        } else{
            timerSmall.invalidate()
            startButton.setTitle("RUN!", for: UIControlState())
            isStarted = false
            self.runner.stopAnimating()
            if(isRunning){
                self.runner.image = UIImage(named: "rrrr1")!
            } else{
                self.runner.image = UIImage(named: "rrrr3")!
            }
        }
    }
    
    @IBAction func restartButtonPressed(_ sender: AnyObject) {
       setTrain()
    }
    
    func setTrain(){
        loadTrain()
        progressLabel.text = "\(NSLocalizedString("runPage.progressLabel", comment: "")): \((ShareData.sharedInstance.userData?.completedTrainsDates?.count)!+1)/27"
        firstStart = true
        isRunning = true
        counterBig = train.temp.reduce(0, +)
        index = 0
        isStarted = false
        runCircles.counterBig = 0
        runCircles.counterSmall = 0
        let screenSize: CGRect = UIScreen.main.bounds
        self.image.image = self.getMixedImg(screenSize.width)
        var timeStr: NSString
        if(Float(train.temp[0]).truncatingRemainder(dividingBy: 60) == 0){
            timeStr = NSString(format:"%0.1d", (train.temp[0])/60)
        } else{
            timeStr = NSString(format:"%.1f", (Float(train.temp[0]))/60)
        }
         stageLabel.text = "\(NSLocalizedString("run.runWord", comment: "")) \(timeStr)\(NSLocalizedString("run.minWord", comment: ""))"
        self.runner.stopAnimating()
        self.runner.image = UIImage(named: "rrrr1")!
        let str = NSString(format:"%0.2d:%0.2d:%0.2d", counter/6000,(counter/100)%60, counter%100)
        smallTimer!.text = str as String
        let str2 = NSString(format:"%0.2d:%0.2d", counterBig/60,counterBig%60)
        bigTimer!.text = str2 as String
        timerSmall.invalidate()
        startButton.setTitle("RUN!", for: UIControlState())

    }
    
    
    
    override func viewDidLoad() {
        print("load")
        super.viewDidLoad()
        
        confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.colors = [UIColor(hex: "#FF7B7B"), UIColor(hex: "#657ECA"), UIColor(hex: "#FFEC7B")]
        progressLabel.text = "\(NSLocalizedString("runPage.progressLabel", comment: "")): \((ShareData.sharedInstance.userData?.completedTrainsDates?.count)!+1)/27"
        
        super.view.autoresizingMask = .flexibleBottomMargin
        //self.view.backgroundColor = UIColor(hex: "#FFF8D7")
        let screenSize: CGRect = UIScreen.main.bounds
        screenWidth = screenSize.width
        loadTrain()
        self.image.image = self.getMixedImg(screenSize.width)
        var timeStr: NSString
        if(Float(train.temp[0]).truncatingRemainder(dividingBy: 60) == 0){
            timeStr = NSString(format:"%0.1d", (train.temp[0])/60)
        } else{
            timeStr = NSString(format:"%.1f", (Float(train.temp[0]))/60)
        }
        stageLabel.font = UIFont(name: "Arial-Black", size: 13.0)
        stageLabel.textColor = UIColor(hex: "#FFFFFF")
        stageLabel.text = "\(NSLocalizedString("run.runWord", comment: "")) \(timeStr)\(NSLocalizedString("run.minWord", comment: ""))"
        self.runner.contentMode = .scaleAspectFit
        self.runner.image = UIImage(named: "rrrr1")!
        let str = NSString(format:"%0.2d:%0.2d:%0.2d", counter/6000,(counter/100)%60, counter%100)
        
        smallTimer = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
        smallTimer!.translatesAutoresizingMaskIntoConstraints = false
        
        smallTimer!.textAlignment = NSTextAlignment.center
        smallTimer!.text = str as String
        //        for family: String in UIFont.familyNames
        //        {
        //            print("\(family)")
        //            for names: String in UIFont.fontNames(forFamilyName: family)
        //            {
        //                print("== \(names)")
        //            }
        //        }
        //UIFont.familyNames.sorted().forEach({print($0)})
        smallTimer!.font = UIFont(name: "Arial-Black", size: 18.0)
        smallTimer!.textColor = UIColor(hex: "#FFFFFF")
        self.runCircles.addSubview(smallTimer!)
        let str2 = NSString(format:"%0.2d:%0.2d", counterBig/60,counterBig%60)
        bigTimer = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
        bigTimer!.translatesAutoresizingMaskIntoConstraints = false
        bigTimer!.textAlignment = NSTextAlignment.center
        bigTimer!.text = str2 as String
        
        bigTimer!.font = UIFont(name: "Arial-Black", size: 32.0)
        bigTimer!.textColor = UIColor(hex: "#FFFFFF")
        self.runCircles.addSubview(bigTimer!)
        
        let horizontalConstraint = NSLayoutConstraint(item: smallTimer!, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: runCircles, attribute: NSLayoutAttribute.centerX, multiplier: 0.5, constant: 0)
        runCircles.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: smallTimer!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: runCircles, attribute: NSLayoutAttribute.centerY, multiplier: 1.5, constant: 0)
        runCircles.addConstraint(verticalConstraint)
        
        let horizontalConstraint2 = NSLayoutConstraint(item: bigTimer!, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: runCircles, attribute: NSLayoutAttribute.centerX, multiplier: 7/6, constant: 0)
        view.addConstraint(horizontalConstraint2)
        
        let verticalConstraint2 = NSLayoutConstraint(item: bigTimer!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: runCircles, attribute: NSLayoutAttribute.centerY, multiplier: 5/6, constant: 0)
        view.addConstraint(verticalConstraint2)
        startButton.titleLabel?.font = UIFont(name: "Arial-Black", size: 35.0)
        startButton.setTitle("RUN!", for: UIControlState())
        muteLabel.text = NSLocalizedString("runPage.muteLabel", comment: "")
        
        //
        //        let imageName = "1.5walk"
        //        let image = UIImage(named: imageName)
        //        sticker = UIImageView(image: image!)
        //
        //        let y = self.view.bounds.height-110
        //        sticker!.frame = CGRect(x: imagePos, y: y, width: 50, height: 50)
        //        self.view.addSubview(sticker!)
        NotificationCenter.default.addObserver(self, selector: #selector(RunController.applicationWillResignActive),name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RunController.applicationDidBecomeActive),name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
    }
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        if !timerSmall.isValid {
            clearDefaults()
        } else {
            saveDefaults()
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func timerActionSmall() {
        if counter%5 == 0{
            counter-=5
        } else{
            counter-=counter%5
        }
        
        if counter%100 == 0{
            counterBig-=1
            runCircles.counterBig += 1
            let str = NSString(format:"%0.2d:%0.2d", counterBig/60, counterBig%60)
            bigTimer!.text = str as String
            updateTrainControlImage()
        }
        if counter < 0 {
            if(index < (train.index)-1){
                isRunning = !isRunning
                index+=1
                let move: String
                let moveEng: String
                if(isRunning){
                    move = NSLocalizedString("run.runWord", comment: "")
                    moveEng = "run"
                    self.runner.animationImages = runningMan
                    runCircles.outlineColorSmall = UIColor(hex: "#E45875")
                    runCircles.smallCircleColor = UIColor(hex: "#FF7B7B")
                } else {
                    move = NSLocalizedString("run.walkWord", comment: "")
                    moveEng = "walk"
                    self.runner.animationImages = walkingMan
                    runCircles.outlineColorSmall = UIColor(hex: "#FFAC66")
                    runCircles.smallCircleColor = UIColor(hex: "#FFD88A")
                    
                }
                self.runner.animationDuration = 0.5
                self.runner.startAnimating()
                var timeStr: NSString
                if Float(train.temp[index]).truncatingRemainder(dividingBy: 60) == 0 {
                    timeStr = NSString(format:"%.1d", (train.temp[index])/60)
                } else{
                    timeStr = NSString(format:"%.1f", (Float(train.temp[index]))/60)
                }
                
                stageLabel.text = "\(move) \(timeStr) \(NSLocalizedString("run.minWord", comment: ""))"
                counter =  train.temp[index]*100
                let str = NSString(format:"%0.2d:%0.2d:%0.2d", counter/6000, (counter/100)%60, counter%100)
                smallTimer!.text = str as String
                runCircles.counterSmall = counter
                runCircles.maxValueSmall = counter
                let audio = "\(moveEng)\(timeStr).mp3"
                SKTAudio.sharedInstance().playSoundEffect(audio)
                return
            }
            if(index == (train.index)-1){
                trainingComplete()
                return
            }
        }
        let str = NSString(format:"%0.2d:%0.2d:%0.2d", counter/6000, (counter/100)%60, counter%100)
        smallTimer!.text = str as String
        runCircles.counterSmall = train.temp[index]*100-counter
        
    }
    
    func trainingComplete(){
        trainingCompeleted = true
        timerSmall.invalidate()
        startButton.setTitle("DONE", for: UIControlState())
        ShareData.sharedInstance.increseNumberOfTrains()
        self.view.addSubview(confettiView)
        confettiView.startConfetti()
        runner.stopAnimating()
        runner.animationImages = [#imageLiteral(resourceName: "rrrr_finish1"),#imageLiteral(resourceName: "rrrr_finish2")]
        runner.startAnimating()
        stageLabel.font = UIFont(name: "Arial-Black", size: 10.0)
        stageLabel.text = NSLocalizedString("runPage.trainEnded", comment: "")
        confTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RunController.confTimerAction), userInfo:nil ,   repeats: true)
    }
    
    func confTimerAction(){
        confTimer.invalidate()
        confettiView.stopConfetti()
        confettiView.removeFromSuperview()
    }
}

//notifications
extension RunController{
    
    private func loadDefaults() {
        deleteNotification()
        let userDefault = UserDefaults.standard
        var restoredCounter = userDefault.object(forKey: PropertyKey.counterKey) as! Int
        var stageIndex = userDefault.object(forKey: PropertyKey.stageKey) as! Int
        let restoredTimeMeasurement = userDefault.object(forKey: PropertyKey.counterMeasurementKey) as! Double
        
        var timeDelta = Int(Date().timeIntervalSince1970 - restoredTimeMeasurement)
        
        if timeDelta < (restoredCounter/100) {
            restoredCounter -= Int(timeDelta * 100)
            counter = restoredCounter
        }else{
            timeDelta -= (restoredCounter/100)
            stageIndex += 1
            while(timeDelta >  train.temp[stageIndex] && stageIndex < train.index){
                timeDelta -= train.temp[stageIndex]
                stageIndex += 1
            }
            if stageIndex < train.index && timeDelta < train.temp[stageIndex] {
                counter = (train.temp[stageIndex] - timeDelta)*100
                index = stageIndex
                counterBig = counter/100
                for i in index+1...train.index-1 {
                    counterBig += train.temp[i]
                }
            } else{
                trainingComplete()
            }
        }
        
    }
    
    func scheduleNotification(identifier: String, title: String, subtitle: String, body: String, timeInterval: TimeInterval, repeats: Bool = false, soundName: String) {
        if #available(iOS 10, *) {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound(named:soundName)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            let notification = UILocalNotification()
            notification.alertBody = "\(title)\n\(subtitle)\n\(body)"
            notification.fireDate = Date(timeIntervalSinceNow: timeInterval)
            notification.soundName = soundName
            
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    func deleteNotification() {
        if #available(iOS 10, *) {
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
    
    func sendAllNotifications(){
        var running = isRunning
        var time = counter/100
        var id = 1
        for i in index+1...train.index-1{
            let mp3name = "\(getNextMoveWord(currentIsRunning: running))\(getTimeString(time: train.temp[i])).mp3"
            let body = "\(getNextMoveWord(currentIsRunning: running))  \(getTimeString(time: train.temp[i]))  \(NSLocalizedString("run.minWord", comment: "")) "
            print("id \(id) time \(time) sound name \(mp3name)")
            scheduleNotification(identifier: "run-girl-\(id)", title: body , subtitle: "", body: body, timeInterval: TimeInterval(time), soundName: mp3name )
            time += train.temp[i]
            running = !running
            id += 1
        }
        
    }
    
    func getTimeString(time:Int) -> NSString{
        var timeStr: NSString
        //print(time)
        if Float(time).truncatingRemainder(dividingBy: 60) == 0 {
            timeStr = NSString(format:"%.1d", time/60)
        } else{
            timeStr = NSString(format:"%.1f", Float(time)/60)
        }
        return timeStr
    }
    
    
    func getNextMoveWord(currentIsRunning:Bool)->String{
        if currentIsRunning {
            return "walk"
        } else {
            return "run"
        }
    }
    
    func isNotificationsAvailable() -> Bool{
        return UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert) ?? false
    }
    
    func saveDefaults() {
        deleteNotification()
        sendAllNotifications()
        let userDefault = UserDefaults.standard
        print("save defaults")
        print("counter \(counter)")
        print("index \(index)")
        userDefault.set(counter, forKey: PropertyKey.counterKey)
        userDefault.set(Date().timeIntervalSince1970, forKey: PropertyKey.counterMeasurementKey)
        userDefault.set(index, forKey: PropertyKey.stageKey)
        userDefault.synchronize()
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
    }
    
    func clearDefaults() {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: PropertyKey.counterKey)
        userDefault.removeObject(forKey: PropertyKey.counterMeasurementKey)
        deleteNotification()
        userDefault.synchronize()
    }
    
    dynamic func applicationWillResignActive() {
        if !timerSmall.isValid {
            clearDefaults()
        } else {
            saveDefaults()
        }
        
    }
    
    dynamic func applicationDidBecomeActive() {
        if timerSmall.isValid {
            loadDefaults()
        }
    }
    
    dynamic func application​Will​Terminate(){
        deleteNotification()
    }
    
    
    
    struct PropertyKey {
        static let counterKey = "RunLikeAGirlRunController_timeCount"
        static let counterMeasurementKey = "RunLikeAGirlRunController_timeMeasurement"
        static let stageKey = "RunLikeAGirlRunController_stageIndex"
        static let isRunningKey = "RunLikeAGirlRunController_isRunning"
    }
}

//rate me
extension RunController{
    
    
    func rateMe() {
        let neverRate = UserDefaults.standard.bool(forKey: "neverRate")
        var numLaunches = UserDefaults.standard.integer(forKey: "numLaunches") + 1
        
        if (!neverRate && (numLaunches == iMinSessions || numLaunches >= (iMinSessions + iTryAgainSessions + 1)))
        {
            showRateMe()
            numLaunches = iMinSessions + 1
        }
        UserDefaults.standard.set(numLaunches, forKey: "numLaunches")
    }
    
    func showRateMe() {
        let alert = UIAlertController(title: NSLocalizedString("rate.Info.title", comment: ""), message: NSLocalizedString("rate.Info.message", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("rate.OK", comment: ""), style: UIAlertActionStyle.default, handler: { alertAction in
            UIApplication.shared.openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id1178891322") as! URL)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("rate.no", comment: ""), style: UIAlertActionStyle.default, handler: { alertAction in
            UserDefaults.standard.set(true, forKey: "neverRate")
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("rate.maybe", comment: ""), style: UIAlertActionStyle.default, handler: { alertAction in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}


//ask for notification

extension RunController: modalAdviceDelegate{
    func notificationAlloweded() {
        registerForNotifications(types:  [.alert, .badge, .sound])
        startButtonPressed()
        
    }
    
    func notificationNotAlloweded() {
        startButtonPressed()
        
    }
    func firstLaunch(){
        UserDefaults.standard.set(true, forKey: "Walkthrough")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? modalAdvice{
            destination.delegate = self
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "modalAdvice" && !isNotificationsAvailable()  && !isStarted {
            return true
        } else{
            startButtonPressed()
        }
        return false
    }
    
    func registerForNotifications(types: UIUserNotificationType) {
        if #available(iOS 10.0, *) {
            let options = types.authorizationOptions()
            UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
                if granted {
                    
                }
            }
        } else {
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
}
//images
extension RunController{
    func updateTrainControlImage(){
        let size = CGSize(width: screenWidth, height: 50)
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        var widthVid: CGFloat = 0
        let percent: CGFloat = (CGFloat((train.temp[index])*100-counter))/CGFloat((train.temp[index]*100))
        
        if(percent < 1)
        {
            let croppedImage: UIImage = ImageUtil.cropFromLeft(image: (train.trainMenu[index]), percent: percent)
            if(croppedImage.size.width > 40){
                croppedImage.draw(in: CGRect(x: widthVid, y: 0, width: croppedImage.size.width, height: croppedImage.size.height))
                widthVid+=croppedImage.size.width
            } else{
                let croppedImage: UIImage = ImageUtil.cropFromLeft(image: (train.trainMenu[index]), percent: CGFloat(40/train.trainMenu[index].size.width))
                croppedImage.draw(in: CGRect(x: widthVid, y: 0, width: croppedImage.size.width, height: croppedImage.size.height))
                widthVid+=40
            }
        }
        if(index == train.index-1){
            #imageLiteral(resourceName: "finish").draw(in: CGRect(x: widthVid, y: 9, width: #imageLiteral(resourceName: "finish").size.width, height: #imageLiteral(resourceName: "finish").size.height))
            
        }
        //let startedPositonForStiker = widthVid
        for i in self.index+1 ..< train.index {
            train.trainMenu[i].draw(in: CGRect(x: widthVid, y: 0, width: train.trainMenu[i].size.width, height: train.trainMenu[i].size.height))
            widthVid+=train.trainMenu[i].size.width
            if(i == train.index-1){
                #imageLiteral(resourceName: "finish").draw(in: CGRect(x: widthVid, y: 9, width: #imageLiteral(resourceName: "finish").size.width, height: #imageLiteral(resourceName: "finish").size.height))
                
            }
            if(widthVid > screenWidth){
                break
            }
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //if(index == (train.index)-1){
        //    self.sticker!.image = UIImage(named: "white")!
        //}
        //else{
        //    if(isRunning){
        //        self.sticker!.image = UIImage(named: "1.5walk")!
        //    } else{
        //        self.sticker!.image = UIImage(named: "1run")!
        //    }
        //}
        self.image.image = finalImage
        //var frame:CGRect = self.sticker!.frame
        //frame.origin.x = startedPositonForStiker
    }
    func getMixedImg(_ width: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: 50)
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        var widthVid: CGFloat = 0
        for im in train.trainMenu {
            if(widthVid + im.size.width < width){
                im.draw(in: CGRect(x: widthVid, y: 0, width: im.size.width, height: im.size.height))
                widthVid+=im.size.width
            } else{
                im.draw(in: CGRect(x: widthVid, y: 0, width: im.size.width, height: im.size.height))
                break
            }
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage!
    }
}


// MARK: - <#Description#>
extension UIUserNotificationType {
    
    @available(iOS 10.0, *)
    func authorizationOptions() -> UNAuthorizationOptions {
        var options: UNAuthorizationOptions = []
        if contains(.alert) {
            options.formUnion(.alert)
        }
        if contains(.sound) {
            options.formUnion(.sound)
        }
        if contains(.badge) {
            options.formUnion(.badge)
        }
        return options
    }
    
}



