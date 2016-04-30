//
//  NetworkManager.m
//  家校通
//
//  Created by Sunny on 4/26/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "NetworkManager.h"
#import <CommonCrypto/CommonDigest.h>

static NetworkManager *_networkManager;

static NSString *_nonce;
static NSString *_timeStamp;

@implementation NetworkManager

+ (NetworkManager * _Nonnull)sharedManager {
    @synchronized (self) {
        if (!_networkManager) {
            _networkManager = [[self alloc]init];
        }
    }
    return _networkManager;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (!_networkManager) {
            _networkManager = [super allocWithZone:zone];
        }
    }
    return _networkManager;
}

- (void)requestByPostWithUrl:(NSString * _Nonnull)url andDict:(NSDictionary * _Nullable)dict finishWithSuccess:(SuccessBlock _Nonnull)success orFailure:(FailureBlock _Nonnull)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 5.f;
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",@"text/javascript", nil];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(operation, error);
    }];
}

- (void)requestRCWithUrl:(NSString * _Nonnull)url andDict:(NSDictionary * _Nullable)dict finishWithSuccess:(SuccessBlock _Nonnull)success orFailure:(FailureBlock _Nonnull)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 5.f;
    _nonce = [self getNonce];
    _timeStamp = [self getTimeStamp];
    [manager.requestSerializer setValue:@"lmxuhwagxvsmd" forHTTPHeaderField:@"App-Key"];
    [manager.requestSerializer setValue:_nonce forHTTPHeaderField:@"Nonce"];
    [manager.requestSerializer setValue:_timeStamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:[self getSignature] forHTTPHeaderField:@"Signature"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",@"text/javascript", nil];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(operation, error);
    }];
}

- (NSString *)getNonce {
    NSString *nonce = [NSString stringWithFormat:@"%ld", random()];
    return nonce;
}

- (NSString *)getTimeStamp {
    NSDate *now = [NSDate new];
    NSString *timeStampFloat = [NSString stringWithFormat:@"%f", [now timeIntervalSince1970]];
    NSString *timeStamp = [timeStampFloat substringToIndex:10];
    return timeStamp;
}

- (NSString *)getSignature {
    NSString *signature = [self sha1:[NSString stringWithFormat:@"TSA4os7Na8eVEk%@%@", _nonce, _timeStamp]];
    NSLog(@"signature: %@", signature);
    return signature;
}

//计算SHA1
- (NSString *) sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
