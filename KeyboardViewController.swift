//
//  KeyboardViewController.swift
//  Neat Keyboard
//
//  Created by Eunkwang Joo on 5/7/15.
//  Copyright (c) 2015 jooddang. All rights reserved.
//
// iphone 6+ thumb reach - w: 930px / 1242px = 74.9% and 20px(->14.98px) between buttons by width and height: 660px (414px/736px in coding)


import UIKit

class KeyboardViewController: UIInputViewController {

    var nextKeyboardButton: UIButton!
	var capsLockOn = false
	var isKeyDown = false
	var numRow, topRow, midRow, lowRow, bottomRow: UIView!
	let keyHeight: CGFloat = 44
	
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }
	
	func createButtons(titles: [String]) -> [UIButton] {
		var buttons = [UIButton]()
		
		for title in titles {
			let button = UIButton.buttonWithType(.System) as! UIButton
			button.setTitle(title, forState: .Normal)
			button.setTranslatesAutoresizingMaskIntoConstraints(false)
			button.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.09, alpha:1)
			button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
			button.layer.borderColor = UIColor.darkGrayColor().CGColor
			button.layer.cornerRadius = 5
			button.layer.borderWidth = 0.5
			button.addTarget(self, action: "keyPressed:", forControlEvents: .TouchUpInside)
			button.addTarget(self, action: "keyDown:", forControlEvents: .TouchDown)
			buttons.append(button)
			
			if title == "ø" {
				button.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
			}
		}
		return buttons
	}
	
	func addConstraints(buttons: [UIButton], containingView: UIView) {
		for (index, button) in enumerate(buttons) {
			var topConstraints = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: containingView, attribute: .Top, multiplier: 1.0, constant: 1)
			var bottomConstraints = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: containingView, attribute: .Bottom, multiplier: 1.0, constant: -1)
//			var topConstraints = NSLayoutConstraint()
//			var bottomConstraints = NSLayoutConstraint()
			
			var leftConstraint: NSLayoutConstraint!
			
			if index == 0 {
				leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: containingView, attribute: .Left, multiplier: 1.0, constant: 1)
			} else {
				leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: buttons[index-1], attribute: .Right, multiplier: 1.0, constant: 1)
				var widthConstraint = NSLayoutConstraint(item: buttons[0], attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0)
				containingView.addConstraint(widthConstraint)
			}
			
			var rightConstraint: NSLayoutConstraint!
			if index == buttons.count - 1 {
				rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: containingView, attribute: .Right, multiplier: 1.0, constant: -1)
			} else {
				rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: buttons[index+1], attribute: .Left, multiplier: 1.0, constant: -1)
			}
			containingView.addConstraints([topConstraints, bottomConstraints, rightConstraint, leftConstraint])
		}
	}
	
	func changeCaps(containerView: UIView) {
		for view in containerView.subviews {
			if let button = view as? UIButton {
				let buttonTitle = button.titleLabel!.text
				if capsLockOn {
					let text = buttonTitle!.uppercaseString
					button.setTitle("\(text)", forState: .Normal)
				} else {
					let text = buttonTitle!.lowercaseString
					button.setTitle("\(text)", forState: .Normal)
				}
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.09, alpha:1);
		self.primaryLanguage = "ko-KR" 
		
		let screenBound = UIScreen.mainScreen().bounds
		let RATIO:CGFloat = 930 / 1242.0
		let rowWidth = screenBound.width * RATIO
		println("screen w: \(screenBound.width) h: \(screenBound.height) and ratio: \(RATIO)")
		
		// number row
		var buttonTitles = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
		var buttons = createButtons(buttonTitles)
		numRow = UIView(frame: CGRectMake(screenBound.width - rowWidth, 0, rowWidth, keyHeight))
//		numRow.layer.borderWidth = 0.5
//		numRow.layer.borderColor = UIColor.whiteColor().CGColor
		
		for button in buttons {
			numRow.addSubview(button)
		}
		
		self.view.addSubview(numRow)
		addConstraints(buttons, containingView: numRow)
		
        // character top row
		buttonTitles = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
		buttons = createButtons(buttonTitles)
		topRow = UIView(frame: CGRectMake(screenBound.width - rowWidth, keyHeight, rowWidth, keyHeight))
//		topRow.layer.borderWidth = 0.5
//		topRow.layer.borderColor = UIColor.whiteColor().CGColor
		
		for button in buttons {
			topRow.addSubview(button)
		}
		
		self.view.addSubview(topRow)
		addConstraints(buttons, containingView: topRow)

		// character mid row
		buttonTitles = ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
		buttons = createButtons(buttonTitles)
		midRow = UIView(frame: CGRectMake(screenBound.width - rowWidth, keyHeight * 2, rowWidth, keyHeight))
//		midRow.layer.borderWidth = 0.5
//		midRow.layer.borderColor = UIColor.whiteColor().CGColor
		
		for button in buttons {
			midRow.addSubview(button)
		}
		
		self.view.addSubview(midRow)
		addConstraints(buttons, containingView: midRow)

		// character low row
		buttonTitles = ["^", "z", "x", "c", "v", "b", "n", "m", "<"]
		buttons = createButtons(buttonTitles)
		lowRow = UIView(frame: CGRectMake(screenBound.width - rowWidth, keyHeight * 3, rowWidth, keyHeight))
//		lowRow.layer.borderWidth = 0.5
//		lowRow.layer.borderColor = UIColor.whiteColor().CGColor
		
		for button in buttons {
			lowRow.addSubview(button)
		}
		
		self.view.addSubview(lowRow)
		addConstraints(buttons, containingView: lowRow)
		
		// character bottom row
		buttonTitles = ["ø", "!", "?", "*", " ", ",", ".", "-", "√"]
		buttons = createButtons(buttonTitles)
		bottomRow = UIView(frame: CGRectMake(screenBound.width - rowWidth, keyHeight * 4, rowWidth, keyHeight))
//		bottomRow.layer.borderWidth = 0.5
//		bottomRow.layer.borderColor = UIColor.whiteColor().CGColor
		
		for button in buttons {
			bottomRow.addSubview(button)
		}
		
		self.view.addSubview(bottomRow)
		addConstraints(buttons, containingView: bottomRow)
		
    }
	
	func keyDown(sender: AnyObject?) {
		let button = sender as! UIButton
		let title = button.titleForState(.Normal)
		if title == "<" {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
				self.isKeyDown = true
				var firstDelete = true
				var d1 = NSDate()
				while self.isKeyDown {
					var diff = d1.timeIntervalSinceNow
					if firstDelete || diff <= -0.2 {
						// keep pressing = continuously deleting
						(self.textDocumentProxy as! UIKeyInput).deleteBackward()
						firstDelete = false
						d1 = NSDate()
					}
				}
			})
		} else if title == "^" || title == "ø" {
		} else {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
				self.isKeyDown = true
				var d1 = NSDate()
				var writeOnce = true
				while self.isKeyDown {
					var diff = d1.timeIntervalSinceNow
					if writeOnce || diff <= -0.2 {
						// keep pressing = continously writing
						if title == "√" {
							(self.textDocumentProxy as! UIKeyInput).insertText("\n")
						} else {
							(self.textDocumentProxy as! UIKeyInput).insertText(title!)
						}
						writeOnce = false
						d1 = NSDate()
					}
				}
			})
		}
	}
	
	func keyPressed(sender: AnyObject?)	 {
		let button = sender as! UIButton
		let title = button.titleForState(.Normal)

		if title == "<" {
			isKeyDown = false
		} else if title == "^" {
			capsLockOn = !capsLockOn
			if capsLockOn {
				button.backgroundColor = UIColor.darkGrayColor()
			} else {
				button.backgroundColor = UIColor.blackColor()
			}
			changeCaps(topRow)
			changeCaps(midRow)
			changeCaps(lowRow)
 		} else {
			isKeyDown = false
		}
	}
	
	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        var proxy = self.textDocumentProxy as! UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
		/*
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
*/
    }

}
