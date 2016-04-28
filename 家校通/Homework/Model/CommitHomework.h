//
//  CommitHomework.h
//  家校通
//
//  Created by Sunny on 4/29/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CommitHomework : JSONModel

@property (nonatomic,copy)NSString <Optional> * data;
@property (nonatomic,copy)NSString <Optional> * message;
@property (nonatomic,copy)NSString <Optional> * responseCode;

@end
