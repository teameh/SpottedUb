//
//  Post.m
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

#import "Post.h"
#import "NSDate+dateToSimpleString.h"
#import "FacebookManager.h"

@implementation Post


- (id) initWithSimpleData:(NSDictionary *)data {
    return [self initWithData:data fullData:NO];

}
- (id) initWithFullData:(NSDictionary *)data{
    return [self initWithData:data fullData:YES];
}

- (id) initWithData:(NSDictionary *)data fullData:(BOOL)full {
    if(self = [super init]){
        _allData = data;
        _type = [data objectForKey:@"type"];

        _message = [data objectForKey:@"message"];
        
        if([_type isEqualToString:@"status"] == NO){
            if([[data objectForKey:@"link"] length] > 0){
                _message = [_message stringByAppendingFormat:@"\n\n %@", [data objectForKey:@"link"]];
            }
        }
        
        _shortMessage = [_message copy];
        //        if([_shortMessage length] > 410){
        //            _shortMessage = [_shortMessage substringWithRange:NSMakeRange(0, 400)];
        //            _shortMessage = [_shortMessage stringByAppendingString:@"..."];
        //        }
        
        _postID = [data objectForKey:@"id"];
        _plainPostID = [[_postID componentsSeparatedByString:@"_"] lastObject];
        
        _date = [NSDate dateFromFacebookString:[data objectForKey:@"created_time"]];
        _likes = [[[data objectForKey:@"likes"] objectForKey:@"count"] intValue];
        _comments = [[[data objectForKey:@"comments"] objectForKey:@"count"] intValue];

        _liked = NO;
        
        for(NSDictionary *likerInfo  in [[data objectForKey:@"likes"] objectForKey:@"data"]){
            if([[likerInfo objectForKey:@"id"] isEqualToString:[[FacebookManager defaultManager] fbUserId]]){
                _liked = YES;
                break;
            }
        }
        
        _fullData = full;
    }
    return self;
}

@end
