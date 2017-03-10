//
//  OnBoardingViewController.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 3/8/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import iCarousel

class OnBoardingViewController: BaseViewController, iCarouselDataSource, iCarouselDelegate, OnBoardingCarouselViewDelegate {
    
    @IBOutlet weak var onBoardingCarousel: iCarousel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var letsRollButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    var carouselViewFrame:CGRect = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height)
    var numberOfElements = ApplicationManager.sharedInstance.onBoardingCards.count
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        onBoardingCarousel.isPagingEnabled = true
        onBoardingCarousel.type = .rotary
        onBoardingCarousel.bounces = false
        pageControl.numberOfPages = numberOfElements
    }
    
    override func viewWillAppear(_ animated: Bool) {
        carouselCurrentItemIndexDidChange(onBoardingCarousel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pageControlValueChanged() {
        onBoardingCarousel.scrollToItem(at: pageControl.currentPage, animated: true)
    }

    @IBAction func skipButtonPressed() {
        if let _ = navigationController {
            dismissViewController(isAnimated: true, dismissed: { (didDismiss) in
            })
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func letsRollButtonPressed() {
        if let _ = navigationController {
            dismissViewController(isAnimated: true, dismissed: { (didDismiss) in
            })
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    //iCarouselDataSource methods
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 8
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if index < numberOfElements {
            let itemView = Bundle.main.loadNibNamed("OnBoardingCarouselView", owner: self, options: nil)?[0] as! OnBoardingCarouselView
            itemView.frame = carouselViewFrame
            itemView.setViewWith(ApplicationManager.sharedInstance.onBoardingCards[index])
            if index == carousel.currentItemIndex {
                itemView.imageWidth.constant = carouselViewFrame.size.width
            } else {
                itemView.imageWidth.constant = carouselViewFrame.size.width*0.5
            }
            if index == numberOfElements-1 {
                itemView.nextButton.isHidden = true
            }
            itemView.delegate = self
            itemView.layoutIfNeeded()
            return itemView
        } else {
            let blankView = UIView()
            blankView.backgroundColor = UIColor.clear
            blankView.frame = carouselViewFrame
            return blankView
        }
    }
    
    //iCarouselDelegate methods
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if carousel.currentItemIndex > numberOfElements-1 {
            carousel.scrollToItem(at: numberOfElements-1, animated: true)
            return
        }
        pageControl.currentPage = carousel.currentItemIndex
        if carousel.currentItemIndex == numberOfElements-1 {
            letsRollButton.isHidden = false
            skipButton.isHidden = true
        } else {
            letsRollButton.isHidden = true
            let currentCard = ApplicationManager.sharedInstance.onBoardingCards[carousel.currentItemIndex]
            if currentCard.required {
                skipButton.isHidden = true
            } else {
                skipButton.isHidden = false
            }
        }
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        if carousel.currentItemIndex > numberOfElements-1 {
            carousel.scrollToItem(at: numberOfElements-1, animated: true)
        }
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option)
        {
        case .wrap:
            return 0
        case .spacing:
            return value * 1.15
        case .visibleItems:
            return 3
        default:
            return value
        }
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
        if carousel.currentItemIndex == numberOfElements-1 && (carousel.scrollOffset - CGFloat(carousel.currentItemIndex) > 0.0){
            carousel.scrollToItem(at: numberOfElements-1, animated: false)
            return
        }
        
        let currentView = carousel.currentItemView as! OnBoardingCarouselView
        let difference = carousel.scrollOffset - CGFloat(carousel.currentItemIndex)
        //modifying current view frame
        let proportionForCurrentView = 1.0 - abs(difference)
        currentView.imageWidth.constant = carouselViewFrame.size.width*proportionForCurrentView
        currentView.layoutIfNeeded()
    }
    
    //OnBoardingCarouselViewDelegate method
    func showNext() {
        if onBoardingCarousel.currentItemIndex < numberOfElements-1 {
            onBoardingCarousel.scrollToItem(at: onBoardingCarousel.currentItemIndex+1, animated: true)
        }
    }
}
