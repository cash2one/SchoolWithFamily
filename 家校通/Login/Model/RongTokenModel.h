//
//  RongTokenModel.h
//  家校通
//
//  Created by Sunny on 4/30/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RongTokenModel : JSONModel

@property (nonatomic,copy)NSString <Optional> * code;
@property (nonatomic,copy)NSString <Optional> * userId;
@property (nonatomic,copy)NSString <Optional> * token;

@end
