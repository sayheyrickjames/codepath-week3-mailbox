//
//  MailboxViewController.swift
//  week3-homework-mailbox
//
//  Created by Rick James! Chatas on 5/20/15.
//  Copyright (c) 2015 SayHey. All rights reserved.
//

import UIKit
import MessageUI

class MailboxViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate {
    
    // all outlets
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    
    @IBOutlet weak var navSegmentedControl: UISegmentedControl!
    @IBOutlet weak var laterScrollView: UIScrollView!
    @IBOutlet weak var archiveScrollView: UIScrollView!
    
    
    // starting center points
    var originalMessageCenter: CGPoint!
    var originalLaterIconCenter: CGPoint!
    var originalArchiveIconCenter:CGPoint!
    var originalDeleteIconCenter: CGPoint!
    var originalFeedCenter: CGPoint!
    var gutter: CGFloat!
    var originalContainerViewCenterX: CGFloat!
    
    
    // colors
    let blueColor = UIColor(red: 107/255, green: 190/255, blue: 219/255, alpha: 1)
    let yellowColor = UIColor(red: 254/255, green: 202/255, blue: 22/255, alpha: 1)
    let brownColor = UIColor(red: 206/255, green: 150/255, blue: 98/255, alpha: 1)
    let greenColor = UIColor(red: 85/255, green: 213/255, blue: 80/255, alpha: 1)
    let redColor = UIColor(red: 231/255, green: 61/255, blue: 14/255, alpha: 1)
    let grayColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // scroll settings
        scrollView.frame.size = view.bounds.size
        scrollView.contentSize = CGSize(width: 320, height: 1432)
        
        originalMessageCenter = messageImageView.center
        
        // starting values
        listIcon.alpha = 0
        deleteIcon.alpha = 0
        
        originalLaterIconCenter = CGPoint(x: messageImageView.frame.width - 30, y: messageImageView.frame.height/2)
        originalArchiveIconCenter = CGPoint(x: 30, y: messageImageView.frame.height/2)
        originalFeedCenter = feedImageView.center
        
        gutter = 30
        rescheduleImageView.alpha = 0
        rescheduleImageView.center = view.center
        
        listImageView.alpha = 0
        listImageView.center = view.center
        
        originalContainerViewCenterX = 160
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // pan gesture recognizer
    
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        containerView.addGestureRecognizer(edgeGesture)
        
        
        // pan began
        if (sender.state == UIGestureRecognizerState.Began){
            
            //set the starting point of the message to its current position
            originalMessageCenter = messageImageView.center
            
            archiveIcon.alpha = 0
            deleteIcon.alpha = 0
            listIcon.alpha = 0
            laterIcon.alpha = 0
            
        }
            
            // pan changed
        else if (sender.state == UIGestureRecognizerState.Changed) {
            
            messageImageView.center = CGPointMake(originalMessageCenter.x + translation.x, originalMessageCenter.y)
            
            
            // short swipe left for later
            if (messageImageView.center.x < 100 && messageImageView.center.x > -40) {
                messageContainerView.backgroundColor = UIColor(red: 255/255, green: 211/255, blue: 32/255, alpha: 1)
                deleteIcon.alpha = 0
                listIcon.alpha = 0
                laterIcon.alpha = 1
                laterIcon.center = CGPointMake(messageImageView.frame.width + gutter + translation.x, messageImageView.center.y)
                
            }
                
                // long swipe left for list
            else if (messageImageView.center.x <= -40) {
                messageContainerView.backgroundColor = UIColor(red: 216/255, green: 166/255, blue: 117/255, alpha: 1)
                deleteIcon.alpha = 0
                laterIcon.alpha = 0
                listIcon.alpha = 1
                listIcon.center = CGPointMake(messageImageView.frame.width + gutter + translation.x, messageImageView.center.y)
                
            }
                
                // short swipe right to archive
            else if (messageImageView.center.x > 220 && messageImageView.center.x < 360) {
                messageContainerView.backgroundColor = UIColor(red: 98/255, green: 216/255, blue: 98/255, alpha: 1)
                laterIcon.alpha = 0
                deleteIcon.alpha = 0
                archiveIcon.alpha = 1
                archiveIcon.center = CGPointMake(translation.x - gutter, messageImageView.center.y)
                
            }
                
                // long swipe right to delete
            else if (messageImageView.center.x >= 360) {
                messageContainerView.backgroundColor = UIColor(red: 239/255, green: 84/255, blue: 12/255, alpha: 1)
                archiveIcon.alpha = 0
                deleteIcon.alpha = 1
                deleteIcon.center = CGPointMake(translation.x - gutter, messageImageView.center.y)
                
            }
                
                // otherwise keep the background gray
            else {
                
                laterIcon.alpha = -translation.x / 60
                archiveIcon.alpha = translation.x / 60
                
                messageContainerView.backgroundColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1)
                laterIcon.center = CGPointMake(originalLaterIconCenter.x, originalLaterIconCenter.y)
                archiveIcon.center = originalArchiveIconCenter
                
            }
            
            
        }
            // pan ended
        else if (sender.state == UIGestureRecognizerState.Ended) {
            
            if (messageImageView.center.x < 100 && messageImageView.center.x > -40){
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageImageView.center.x = -self.view.frame.width
                    self.laterIcon.center.x = self.messageImageView.center.x + self.messageImageView.frame.width/2 + self.gutter
                    self.rescheduleImageView.alpha = 1
                })
                
            }
                
                
                // list
            else if (messageImageView.center.x <= -40) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageImageView.center.x = -self.view.frame.width
                    self.listIcon.center.x = self.messageImageView.center.x + self.messageImageView.frame.width/2 + self.gutter
                    self.listImageView.alpha = 1
                    
                })
                
            }
                
                
                // archive
            else if (messageImageView.center.x > 220 && messageImageView.center.x < 360) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageImageView.center.x = self.view.frame.width * 2
                    self.archiveIcon.center.x = self.messageImageView.center.x - self.gutter
                    
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.feedImageView.center.y = self.feedImageView.center.y - self.messageImageView.frame.height
                            
                        })
                        
                })
                
                
            }
                // delete
            else if (messageImageView.center.x >= 360) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageImageView.center.x = self.view.frame.width * 2
                    self.deleteIcon.center.x = self.messageImageView.center.x - self.gutter
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.feedImageView.center.y = self.feedImageView.center.y - self.messageImageView.frame.height
                            
                        })
                        
                })
            }
                
                // didn't swipe far enough, return to original position
            else {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageImageView.center.x = self.view.frame.width/2
                })
            }
        }
        
    }
    
    
    @IBAction func didTapReschedulePane(sender: UITapGestureRecognizer) {
        self.archiveIcon.alpha = 0
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.rescheduleImageView.alpha = 0
            self.messageImageView.center.x = self.view.frame.width/2
            self.laterIcon.center.x = self.messageImageView.center.x + self.messageImageView.frame.width/2 + self.gutter
        })
    }
    
    
    @IBAction func didTapListPane(sender: UITapGestureRecognizer) {
        self.archiveIcon.alpha = 0
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.listImageView.alpha = 0
            self.messageImageView.center.x = self.view.frame.width/2
            self.listIcon.center.x = self.messageImageView.center.x + self.messageImageView.frame.width/2 + self.gutter
        })
    }
    
    
    @IBAction func didPressResetButton(sender: AnyObject) {
        messageImageView.center.x = view.frame.width/2
        feedImageView.center = originalFeedCenter
    }
    
    
    @IBAction func didPressMenuButton(sender: AnyObject) {
        if (containerView.center.x == view.frame.width/2) {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.containerView.center.x += 280
            })
            
        }
            
        else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.containerView.center.x = self.view.frame.width/2
            })
        }
        
        
    }
    
    
    @IBAction func didPressComposeButton(sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail(){
            var composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients(["rchatas@icloud.com"])
            composer.navigationBar.tintColor = blueColor
            presentViewController(composer, animated: true, completion: {
                UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
            })
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        switch result.value{
        case MFMailComposeResultCancelled.value: println("Mail cancelled")
        case MFMailComposeResultSaved.value: println("Mail saved")
        case MFMailComposeResultSent.value: println("Mail sent")
        case MFMailComposeResultFailed.value: println("Failed to send mail: \(error.localizedDescription)")
            
        default:
            break
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent)
//    {
//        if(event.subtype == UIEventSubtype.MotionShake)
//        {
//            //If the user has archived or deleted a message, bring up this alert
//            if (self.feedImageView.frame == CGRect(x: 320, y: 0, width: 320, height: 1202))
//            {
//                //Alert declaration
//                var alert = UIAlertController(title: "Undo last action?", message: "Are you sure you want to undo and move 1 item from Archive back into inbox?", preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
//                alert.addAction(UIAlertAction(title: "Undo", style: UIAlertActionStyle.Default, handler: {(alertAction) -> Void in
//                    self.undismissMessage()
//                }))
//                //Show alert
//                self.presentViewController(alert, animated: true, completion: nil)
//            }
//        }
//    }
//    
    
    // edge pan gesture recognizer
    
    func onEdgePan(sender:UIScreenEdgePanGestureRecognizer) {
        var translation = sender.translationInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began){
            
            originalContainerViewCenterX = containerView.center.x
        }
            
        else if (sender.state == UIGestureRecognizerState.Changed) {
            containerView.center.x = originalContainerViewCenterX + translation.x
        }
            
        else if (sender.state == UIGestureRecognizerState.Ended) {
            
            if (translation.x < 100) {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
                    self.containerView.center.x = 160
                    }, completion: { (Bool) -> Void in
                })
                
            } else if (translation.x >= 100) {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
                    self.containerView.center.x = 440
                    }, completion: { (Bool) -> Void in
                })
                
            }
            
        }
        
    }
    
    @IBAction func tapNavSegmentedControl(sender: AnyObject) {
        
        if navSegmentedControl.selectedSegmentIndex == 0 {
            
            // later icon selected
            
            navSegmentedControl.tintColor = yellowColor
            
            self.laterScrollView.alpha = 1
            
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                self.scrollView.frame.origin.x = 320
                }, completion: { (Bool) -> Void in
                    self.scrollView.alpha = 0
            })
            
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                self.archiveScrollView.frame.origin.x = 640
                }, completion: { (Bool) -> Void in
                    self.archiveScrollView.alpha = 0
            })
            
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                self.laterScrollView.frame.origin.x = 0
                }, completion: { (Bool) -> Void in
                    self.laterScrollView.alpha = 1
            })
            
            
        } else if navSegmentedControl.selectedSegmentIndex == 1 {
            
            // mailbox icon selected
            
            navSegmentedControl.tintColor = blueColor
            
            self.scrollView.alpha = 1
            
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                self.scrollView.frame.origin.x = 0
                }, completion: { (Bool) -> Void in
                    self.scrollView.alpha = 1
            })
            
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                self.archiveScrollView.frame.origin.x = 320
                }, completion: { (Bool) -> Void in
                    self.archiveScrollView.alpha = 0
            })
            
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                self.laterScrollView.frame.origin.x = -320
                }, completion: { (Bool) -> Void in
                    self.laterScrollView.alpha = 0
            })
            
            
        } else {
            
            // archive icon selected
            
            navSegmentedControl.tintColor = greenColor
            
            archiveScrollView.alpha = 1
            
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                self.scrollView.frame.origin.x = -320
                }, completion: { (Bool) -> Void in
                    self.scrollView.alpha = 0
            })
            
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                self.archiveScrollView.frame.origin.x = 0
                }, completion: { (Bool) -> Void in
                    self.archiveScrollView.alpha = 1
            })
            
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                self.laterScrollView.frame.origin.x = -640
                }, completion: { (Bool) -> Void in
                    self.laterScrollView.alpha = 0
            })
            
        }
    }
    
}


/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/
