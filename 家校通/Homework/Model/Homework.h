//
//  Homework.h
//  家校通
//
//  Created by Sunny on 4/26/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol HomeworkData

@end

@interface HomeworkData : JSONModel

@property (nonatomic,copy)NSString <Optional> * homeworkId;
@property (nonatomic,copy)NSString <Optional> * homeworkTitle;
@property (nonatomic,copy)NSString <Optional> * homeworkDetail;
@property (nonatomic,copy)NSString <Optional> * homeworkScore;
@property (nonatomic,copy)NSString <Optional> * homeworkDate;
@property (nonatomic,copy)NSString <Optional> * userId;

@end

@interface Homework : JSONModel

@property (nonatomic,copy)NSArray <Optional, HomeworkData> * data;
@property (nonatomic,copy)NSString <Optional> * message;
@property (nonatomic,copy)NSString <Optional> * responseCode;

@end
