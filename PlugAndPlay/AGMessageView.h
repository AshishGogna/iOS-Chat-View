//
//  AGMessageView.h
//  AGChatView
//
//  Created by Ashish Gogna on 10/04/16.
//  Copyright © 2016 Ashish Gogna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGMessageView : UIView

- (UIView*)createMessageWithScreenWidth: (CGFloat)screenWidth Text: (NSString*)text Image: (UIImage*)image DateTime: (NSString*)dateTimeString isReceived: (BOOL)isReceived;

@end
