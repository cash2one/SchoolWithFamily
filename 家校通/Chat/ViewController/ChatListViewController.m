//
//  ChatListViewController.m
//  家校通
//
//  Created by Sunny on 4/30/16.
//  Copyright © 2016 Sunny. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "AddChatViewController.h"

@interface ChatListViewController () {
    UIBarButtonItem *_createChatBtn;
}

@end

@implementation ChatListViewController

- (instancetype)init {
    if (self = [super init]) {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION)]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _createChatBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createChat)];
    self.cellBackgroundColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = _createChatBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *conversationVC = [ChatViewController new];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.targetId;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)createChat {
    AddChatViewController *addChatVC = [[AddChatViewController alloc] init];
    [self.navigationController pushViewController:addChatVC animated:YES];
}

@end
