//
//  FacebookManager.h
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

#import "FacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"

@implementation FacebookManager

- (void) getFBUserInfo {
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", [error localizedDescription]);
            return;
        }
        
        if([result isKindOfClass:[NSDictionary class]] == NO){
            NSLog(@"Error: result is no dictionary");
            return;
        }
        
        [self setFbUserInfo:result];
        [self setFbUserId:[result objectForKey:@"id"]];
    }];
}

- (void) getPosts:(BOOL)more
        withBlock:(void (^)(NSArray *posts)) succesBlock
          failure:(void (^)(NSError *theError)) failureBlock {
    
    if(more){
        
        NSString *path = [NSString stringWithFormat:@"260621897399602/feed?limit=25&until=%@", [self nextURL]];
        
        [self getPostsWithGraphPath:path withBlock:^(NSArray *posts) {
            
            [[self posts] addObjectsFromArray:posts];
            succesBlock ([self posts]);
            
        } failure:^(NSError *theError) {
            failureBlock(theError);
        }];
        
    }else{
        [self getPostsWithGraphPath:@"260621897399602/feed?limit=25" withBlock:^(NSArray *posts) {
            
            [self setPosts:[posts mutableCopy]];
            succesBlock ([self posts]);
            
        } failure:^(NSError *theError) {
            failureBlock(theError);
        }];
    }
}

- (void) getPostDetail:(NSString *)postID
                 index:(int)index
             withBlock:(void (^)(NSArray *posts)) succesBlock
          failure:(void (^)(NSError *theError)) failureBlock {
    
    Post *post = [[self posts] objectAtIndex:index];
    if([[post postID] isEqualToString:postID]){
        
        [FBRequestConnection startWithGraphPath:postID completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error != nil) {
                NSLog(@"Error: %@", [error localizedDescription]);
                failureBlock(error);
                return;
            }

            if([result isKindOfClass:[NSDictionary class]] == NO){
                NSError *error = [NSError errorWithDomain:@"failure result is no dictionary" code:0 userInfo:nil];
                failureBlock(error);
                return;
            }
            
            Post *post = [[Post alloc] initWithFullData:result];
            if(post != nil){
                [[self posts] replaceObjectAtIndex:index withObject:post];
                succesBlock ([self posts]);
            }else{
                NSError *error = [NSError errorWithDomain:@"failure in creating post" code:0 userInfo:nil];
                failureBlock(error);
                return;
            }
        }];
    }
    
}

- (void) likePost:(Post *)post
        withBlock:(void (^)(id result)) succesBlock
          failure:(void (^)(NSError *theError)) failureBlock {
    
    NSURL *baseURL = [NSURL URLWithString:@"https://graph.facebook.com/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];

    NSDictionary *params = @{@"access_token" : FBSession.activeSession.accessToken};

    if([post liked] == NO){
        NSString *link = [NSString stringWithFormat:@"/%@/likes", [post postID]];
        [httpClient postPath:link parameters:params success:^(AFHTTPRequestOperation *op, id result) {
                       
            DLog(@"result %@", result);
            [post setLiked:YES];
            succesBlock(post);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            DLog(@"error %@", error);
            
        }];
    }else{
        NSString *link = [NSString stringWithFormat:@"/%@/likes", [post postID]];
        [httpClient deletePath:link parameters:params success:^(AFHTTPRequestOperation *op, id result) {
            
            DLog(@"result %@", result);
            [post setLiked:NO];
            succesBlock(post);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            DLog(@"error %@", error);
            
        }];
    }
    
    
    
}

//helper
- (void) getPostsWithGraphPath:(NSString *)path
                     withBlock:(void (^)(NSArray *posts)) succesBlock
                       failure:(void (^)(NSError *theError)) failureBlock {
    
    [FBRequestConnection startWithGraphPath:path completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error: %@", [error localizedDescription]);
            failureBlock(error);
            return;
        }
        
        id postData = [result objectForKey:@"data"];

        if(postData == nil){
            NSError *error = [NSError errorWithDomain:@"failure no post data" code:0 userInfo:nil];
            failureBlock(error);
            return;
        }
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *data in postData) {
            
            if([data isKindOfClass:[NSDictionary class]] == NO){
                NSError *error = [NSError errorWithDomain:@"failure data is no dictionary" code:0 userInfo:nil];
                failureBlock(error);
                return;
            }

            Post *post = [[Post alloc] initWithSimpleData:data];
            if(post != nil){
                [array addObject:post];
            }
        }
        
        NSString *next = [[result objectForKey:@"paging"] objectForKey:@"next"];
        if(next != nil){
            NSMutableDictionary *vars = [self parseUrl:next];
            next = [vars objectForKey:@"until"];
            NSLog(@"next = %@", next);
            [self setNextURL:next];
        }

        succesBlock(array);
    }];
}

//helper
- (NSMutableDictionary *) parseUrl:(NSString *)url{
    NSArray *pairs = [url componentsSeparatedByString:@"&"];
    NSMutableDictionary *vars = [NSMutableDictionary dictionary];
    for (NSString *pair in pairs) {
        NSArray *bits = [pair componentsSeparatedByString:@"="];
        NSString *key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSString *value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        [vars setObject:value forKey:key];
    }
    return vars;
}

#pragma mark - Singleton Object methods
//see http://stackoverflow.com/questions/2199106/thread-safe-instantiation-of-a-singleton
+ (FacebookManager *)defaultManager {
    
    static FacebookManager *defaultManager = nil;
    
    static dispatch_once_t runOnlyOnceToken;
    dispatch_once(&runOnlyOnceToken, ^{
        defaultManager = [[super allocWithZone:NULL] init]; // INIT MAY NOT CONTAIN [self defaultmanager]
    });
    
    return defaultManager;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self defaultManager];
}

@end
