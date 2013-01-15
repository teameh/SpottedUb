//
//  NSDate+Additions.m
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

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

static NSDateFormatter *facebookFormatter = nil;
+ (NSDate *) dateFromFacebookString:(NSString *)date {
    
    //create the dateformatter only once
    if (facebookFormatter == nil) {
        facebookFormatter = [[NSDateFormatter alloc] init];
        [facebookFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [facebookFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        ELog(@"statsdateFormatter created with timeZone %@", [facebookFormatter timeZone]);
    }
    
    ELog(@"STRING = %@, DATE = %@", date, [facebookFormatter dateFromString:date]);
    return [facebookFormatter dateFromString:date];
}

@end
