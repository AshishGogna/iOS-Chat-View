//
//  AGChatViewController.h
//  AGChatView
//
//  Created by Ashish Gogna on 09/04/16.
//  Copyright © 2016 Ashish Gogna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end
