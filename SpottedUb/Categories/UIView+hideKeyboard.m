//
//  UIView+hideKeyboard.m
//  SpottedUb
//
//  Created by Tieme van Veen on 1/9/13.
//  Copyright (c) 2012 Tieme van Veen, Wout Hoekstra
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "UIView+hideKeyboard.h"

@implementation UIView (hideKeyboard)

- (void) resignFirstResponderToHideKeyboard {
    
    //http://stackoverflow.com/a/10964295/672989
    
    // Called here to avoid calling it iteratively unnecessarily.
    Class viewControllerClass = [UIViewController class];
    
    //get responder
    UIResponder *responder = self.superview != nil ? self.superview : self;
    
    //traverse up all responders...
    while ((responder = [responder nextResponder])) {
        
        //...till we find a viewcontroller
        if ([responder isKindOfClass:viewControllerClass]) {
            
            //end editing to hide keyboard
            [[(UIViewController *)responder view] endEditing:YES];
            
            return;
        }
    }
}

@end