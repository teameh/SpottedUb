//
//  PostCell.m
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
#import "PostCell.h"

@implementation PostCell

- (void) awakeFromNib {
        
    [[self postView] setAutoresizesSubviews:YES];

    [self setPostTextView:[[UITextView alloc] initWithFrame:CGRectInset(self.postView.frame, 8, 8)]];
    [[self postTextView] setFont:[UIFont systemFontOfSize:14.0]];
    [[self postTextView] setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [[self postTextView] setEditable:NO];
    [[self postTextView] setDataDetectorTypes:UIDataDetectorTypeAll];
    [[self postTextView] setBackgroundColor:[UIColor whiteColor]];
    [[self postView] addSubview:[self postTextView]];
    [[self postView] bringSubviewToFront:[self dateLabel]];
        
    UIImage *image = [[UIImage imageNamed:@"top"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 7, 0, 7)];
    [[self backgroundImage] setImage:image];
    
    image = [[UIImage imageNamed:@"left_bottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 7, 17, 0)];
    [[self likeButton] setBackgroundImage:image forState:UIControlStateNormal];

    image = [[UIImage imageNamed:@"right_bottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 0, 17, 7)];
    [[self commentsButton] setBackgroundImage:image forState:UIControlStateNormal];
    
    [[self bottomView] setBackgroundColor:[UIColor colorWithRed:255./255. green:206./255. blue:206./255. alpha:1]];
    [[self postView] setBackgroundColor:[UIColor colorWithRed:255./255. green:206./255. blue:206./255. alpha:1]];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = CGRectMake(8, 28, 0, 0); //some space for label
    frame.size = [[self postTextView] contentSize];
    [[self postTextView] setFrame:frame];
    
    [[self likeButton] sizeToFit];
    CGRect likeFrame = [[self likeButton] frame];
    likeFrame.size.width += 8;
    likeFrame.size.height = 33;
    [[self likeButton] setFrame:likeFrame];
    [[self likeButton] setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];

    CGRect dotFrame = [[self dot] frame];
    dotFrame.origin.x = likeFrame.origin.x + likeFrame.size.width + 4;
    [[self dot] setFrame:dotFrame];
    
    CGRect cFrame = likeFrame;
    cFrame.origin.x = cFrame.origin.x + cFrame.size.width;
    cFrame.size.width = CGRectGetMaxX(self.commentsButton.frame) - cFrame.origin.x;
    [[self commentsButton] setFrame:cFrame];
    [[self likeButton] setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
}

- (void)setContentText:(NSString *)theText {
    self.postTextView.text = theText;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
