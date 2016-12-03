




import UIKit

class OnboardingController: UIViewController, UIScrollViewDelegate {
    let backgroundColor = UIColor(red:0.03, green:0.53, blue:0.90, alpha:1.0)
    let slides = [
        [ "image": "googleform2.png", "Title": "Thank you installed!","text":"This is TimeCard application.This app uses Bluetooth function. "],
        [ "image": "googleform2.png", "Title": "1:Create google form!","text":"1st Please create google form on the website. 2nd Enter Form's URL that is your created.When you create form,Push 'create' button!"],
        [ "image": "googleform2.png", "Title": "Let's use this app!","text":"OK! Completed!"],
        ]
    let screen: CGRect = UIScreen.main.bounds
    var scroll: UIScrollView?
    var dots: UIPageControl?
    var a = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        scroll = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: screen.width, height: screen.height * 0.9))
        scroll?.showsHorizontalScrollIndicator = false
        scroll?.showsVerticalScrollIndicator = false
        scroll?.isPagingEnabled = true
        
        scroll?.delegate = self
        view.addSubview(scroll!)
        if (slides.count > 1) {
            dots = UIPageControl(frame: CGRect(x: 0.0, y: screen.height * 0.875, width: screen.width, height: screen.height * 0.05))
            dots?.numberOfPages = slides.count
            view.addSubview(dots!)
        }
        for i in 0 ..< slides.count {
            if let image = UIImage(named: slides[i]["image"]!) {
                let imageView: UIImageView = UIImageView(frame: getFrame(iW: image.size.width, iH: image.size.height, slide: i, offset: screen.height * 0.15))
                imageView.image = image
                scroll?.addSubview(imageView)
            }
            
            //title
            if let title = slides[i]["Title"]{
                let titleView = UITextView(frame: CGRect(x:screen.width * 0.05 + CGFloat(i) * screen.width,y:100,width: screen.width * 0.9, height: 100.0))
                titleView.text = title
                titleView.font = UIFont(name:"Apple Color Emoji",size:48)
                titleView.isEditable = false
                titleView.isSelectable = false
                titleView.textAlignment = NSTextAlignment.center
                titleView.font = UIFont.systemFont(ofSize: 35, weight: 0)
                titleView.textColor = UIColor.white
                titleView.backgroundColor = UIColor.clear
                scroll?.addSubview(titleView)
            }
            
            //text
            if let text = slides[i]["text"] {
                let textView = UITextView(frame: CGRect(x: screen.width * 0.05 + CGFloat(i) * screen.width, y: 400, width: screen.width * 0.9, height: 100.0))
                textView.text = text
                textView.font = UIFont(name:"Apple Color Emoji",size:20)
                textView.isEditable = false
                textView.isSelectable = false
                textView.textAlignment = NSTextAlignment.center
                textView.font = UIFont.systemFont(ofSize: 20, weight: 0)
                textView.textColor = UIColor.white
                textView.backgroundColor = UIColor.clear
                scroll?.addSubview(textView)
            }
        }
        scroll?.contentSize = CGSizeMake(CGFloat(Int(screen.width) *  slides.count), screen.height * 0.5)
        scroll?.delegate = self
        dots?.addTarget(self, action: Selector("swipe:"), for: UIControlEvents.valueChanged)
        let cleateButton = UIButton()
        cleateButton.frame = CGRect(x: screen.width - 70, y: 70, width: 60, height: 60)
        cleateButton.setTitle("Cleate", for: .normal)
        cleateButton.addTarget(self, action: #selector(onClickMyButton(sender:)), for: .touchUpInside)
        view.addSubview(cleateButton)
        
    }
    
    
    func pressed(sender: UIButton!) {
        self.dismiss(animated: true) { () -> Void in
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func getFrame (iW: CGFloat, iH: CGFloat, slide: Int, offset: CGFloat) -> CGRect {
        let mH: CGFloat = screen.height * 0.50
        let mW: CGFloat = screen.width
        var h: CGFloat
        var w: CGFloat
        let r = iW / iH
        if (r <= 1) {
            h = min(mH, iH)
            w = h * r
        } else {
            w = min(mW, iW)
            h = w / r
        }
        
        
        return CGRectMake(
            max(0, (mW - w) / 2) + CGFloat(slide) * screen.width,
            max(0, (mH - h) / 2) + offset,
            w,
            h
        )
    }
    func swipe(sender: AnyObject) -> () {
        if let scrollView = scroll {
            let x = CGFloat(dots!.currentPage) * scrollView.frame.size.width
            scroll?.setContentOffset(CGPointMake(x, 0), animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        dots!.currentPage = Int(pageNumber)
        //a += 1
        //print(a)
        print(pageNumber)
        if Float(pageNumber)==2.0{
            // 遷移するViewを定義する.
            // let putViewController: UIViewController = putUrlViewController()
           // let SecondViewController: UIViewController = putUrlViewController()
            let secondViewController: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "putUrl") as! putUrlViewController
            // Viewの移動する.
            //self.present(putViewController, animated: true, completion: nil)
            self.navigationController?.pushViewController(secondViewController, animated: true)
            
        }
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func CGPointMake(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    func CGSizeMake(_ width: CGFloat, _ height: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }
    func onClickMyButton(sender: UIButton){
        
        // 遷移するViewを定義する.
        let mySecondViewController: UIViewController = createViewController()
        
        // アニメーションを設定する.
        //mySecondViewController.modalTransitionStyle = .partialCurl
        
        // Viewの移動する.
        //self.present(mySecondViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(mySecondViewController, animated: true)
    }
    
}
