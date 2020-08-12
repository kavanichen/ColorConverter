//
//  HSVConverterViewController.swift
//  ColorConverter
//
//  Created by Dai Tran on 10/21/17.
//  Copyright © 2017 DaiTranDev. All rights reserved.
//

import UIKit
import SideMenu
import MessageUI
import GoogleMobileAds

class HSVConverterViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var hValueLabel: UILabel!
    @IBOutlet weak var sValueLabel: UILabel!
    @IBOutlet weak var vValueLabel: UILabel!
    
    @IBOutlet weak var hLabel: UILabel!
    @IBOutlet weak var sLabel: UILabel!
    @IBOutlet weak var vLabel: UILabel!

    @IBOutlet weak var hValueSlider: UISlider!
    @IBOutlet weak var sValueSlider: UISlider!
    @IBOutlet weak var vValueSlider: UISlider!
    
    lazy var valueLabelArray:[UILabel] = [hValueLabel, sValueLabel, vValueLabel]
    
    lazy var labelArray: [UILabel] = [hLabel, sLabel, vLabel]
    
    lazy var sliderArray:[UISlider] = [hValueSlider, sValueSlider, vValueSlider]
    
    let defaultValueTextField:[Int] = [180, 50, 50]
    
    let mainBackgroundColor:[UIColor] = [UIColor.white, UIColor.black]
    
    let mainLabelColor: [UIColor] = [UIColor.black, UIColor.orange]
        
    var bannerView: GADBannerView!
    
    @IBOutlet weak var viewColor: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-7005013141953077/9075404978"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        for i in 0..<sliderArray.count {
            sliderArray[i].isEnabled = false
        }
        
        // Do any additional setup after loading the view.
        viewColor.layer.cornerRadius = 10
        viewColor.layer.masksToBounds = true
        
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnRefreshAction(_ sender: Any) {
        for i in 0..<3 {
            valueLabelArray[i].text = String(defaultValueTextField[i])
            sliderArray[i].value = Float(defaultValueTextField[i])
        }
        UtilitiesConverter.rgb = nil
        showColor()
    }
    
    @IBAction func OnSlideValueChanged(_ sender: UISlider) {
        valueLabelArray[sender.tag].text = String(Int(sender.value))
        UtilitiesConverter.rgb = nil
        showColor()
    }
    
    func showColor() {
        let rgbValue = UtilitiesConverter.rgb ?? UtilitiesConverter.hsv2rgb((hue: CGFloat(sliderArray[0].value/360), saturation: CGFloat(sliderArray[1].value/100), brightness: CGFloat(sliderArray[2].value/100), alpha: CGFloat(1)))
        
        if let rgb = UtilitiesConverter.rgb  {
            let hsvValue = UtilitiesConverter.rgb2hsv(rgb)
            sliderArray[0].value = Float(hsvValue.hue)*360
            sliderArray[1].value = Float(hsvValue.saturation)*100
            sliderArray[2].value = Float(hsvValue.brightness)*100
            for i in 0..<sliderArray.count {
                valueLabelArray[i].text = String(Int(sliderArray[i].value))
            }
        }
        
        let red = rgbValue.red
        let green = rgbValue.green
        let blue = rgbValue.blue
        let alpha = CGFloat(1.0)
        
        viewColor?.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        UtilitiesConverter.rgb = (red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: topLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
        
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}

