//
//  NetworkManager.m
//  家校通
//
//  Created by Sunny on 4/26/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "NetworkManager.h"

static NetworkManager *networkManager;

@implementation NetworkManager

+ (NetworkManager * _Nonnull)sharedManager {
    @synchronized (self) {
        if (!networkManager) {
            networkManager = [[self alloc]init];
        }
    }
    return networkManager;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (!networkManager) {
            networkManager = [super allocWithZone:zone];
        }
    }
    return networkManager;
}

- (void)requestByPostWithUrl:(NSString * _Nonnull)url andDict:(NSDictionary * _Nullable)dict finishWithSuccess:(SuccessBlock _Nonnull)success orFailure:(FailureBlock _Nonnull)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",@"text/javascript", nil];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(operation, error);
    }];
}

@end
