//
//  NetworkManager.h
//  家校通
//
//  Created by Sunny on 4/26/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject);
typedef void (^FailureBlock)(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error);

@interface NetworkManager : NSObject

+ (NetworkManager * _Nonnull)sharedManager;
- (void)requestByPostWithUrl:(NSString * _Nonnull)url andDict:(NSDictionary * _Nullable)dict finishWithSuccess:(SuccessBlock _Nonnull)success orFailure:(FailureBlock _Nonnull)failure;
- (void)requestRCWithUrl:(NSString * _Nonnull)url andDict:(NSDictionary * _Nullable)dict finishWithSuccess:(SuccessBlock _Nonnull)success orFailure:(FailureBlock _Nonnull)failure;

@end
