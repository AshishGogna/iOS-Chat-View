//
//  AGChatViewController.m
//  AGChatView
//
//  Created by Ashish Gogna on 09/04/16.
//  Copyright © 2016 Ashish Gogna. All rights reserved.
//

#import "AGChatViewController.h"

@interface AGChatViewController ()

//All messages array (contains UIViews)
@property (nonatomic) NSArray *allMessages;

@end

@implementation AGChatViewController

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Example title
    self.navigationItem.title = @"Ms. White";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self createExampleChat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIView *chatBubble = [self.allMessages objectAtIndex:indexPath.row];
    chatBubble.tag = indexPath.row;

    for (int i=0; i<cell.contentView.subviews.count; i++)
    {
        UIView *subV = cell.contentView.subviews[i];
        
        if (subV.tag != chatBubble.tag)
            [subV removeFromSuperview];
        
    }
    
    [cell.contentView addSubview:chatBubble];
    
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *bubble = self.allMessages[indexPath.row];
    return bubble.frame.size.height+20;
}

#pragma mark - Message UI creation function(s)

- (UIView*)createMessageWithScreenWidth: (CGFloat)screenWidth Text: (NSString*)text Image: (UIImage*)image DateTime: (NSString*)dateTimeString isReceived: (BOOL)isReceived
{
    CGFloat maxBubbleWidth = screenWidth-50;
    
    UIView *chatBubbleView = [[UIView alloc] init];
    chatBubbleView.backgroundColor = [UIColor whiteColor];
    chatBubbleView.layer.masksToBounds = YES;
    chatBubbleView.clipsToBounds = NO;
    chatBubbleView.layer.cornerRadius = 4;
    chatBubbleView.layer.shadowOffset = CGSizeMake(0, 0.7);
    chatBubbleView.layer.shadowRadius = 4;
    chatBubbleView.layer.shadowOpacity = 0.2;
    
    UIView *chatBubbleContentView = [[UIView alloc] init];
    chatBubbleContentView.backgroundColor = [UIColor whiteColor];
    chatBubbleContentView.clipsToBounds = YES;
    
    //Add time
    UILabel *chatTimeLabel;
    if (dateTimeString != nil)
    {
        chatTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 16)];
        chatTimeLabel.font = [UIFont systemFontOfSize:10];
        chatTimeLabel.text = dateTimeString;
        chatTimeLabel.textColor = [UIColor lightGrayColor];
        
        [chatBubbleContentView addSubview:chatTimeLabel];
    }
    
    //Add Image
    UIImageView *chatBubbleImageView;
    if (image != nil)
    {
        chatBubbleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26, maxBubbleWidth-30, maxBubbleWidth-30)];
        chatBubbleImageView.image = image;
        chatBubbleImageView.contentMode = UIViewContentModeScaleAspectFill;
        chatBubbleImageView.layer.masksToBounds = YES;
        chatBubbleImageView.layer.cornerRadius = 4;
        
        [chatBubbleContentView addSubview:chatBubbleImageView];
    }
    
    //Add Text
    UILabel *chatBubbleLabel;
    if (text != nil)
    {
        UIFont *messageLabelFont = [UIFont systemFontOfSize:16];
        
        CGSize maximumLabelSize;
        if (chatBubbleImageView != nil)
        {
            maximumLabelSize = CGSizeMake(chatBubbleImageView.frame.size.width, 1000);
            
            CGSize expectedLabelSize = [text sizeWithFont:messageLabelFont constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
            
            chatBubbleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 21+chatBubbleImageView.frame.size.height, expectedLabelSize.width, expectedLabelSize.height+10)];
        }
        else
        {
            maximumLabelSize = CGSizeMake(maxBubbleWidth, 1000);
            
            CGSize expectedLabelSize = [text sizeWithFont:messageLabelFont constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
            
            chatBubbleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, expectedLabelSize.width, expectedLabelSize.height)];
        }
        
        chatBubbleLabel.frame = CGRectMake(chatBubbleLabel.frame.origin.x, chatBubbleLabel.frame.origin.y+5, chatBubbleLabel.frame.size.width, chatBubbleLabel.frame.size.height+10);
        
        chatBubbleLabel.text = text;
        chatBubbleLabel.font = messageLabelFont;
        chatBubbleLabel.numberOfLines = 100;
        
        [chatBubbleContentView addSubview:chatBubbleLabel];
    }
    
    
    [chatBubbleView addSubview:chatBubbleContentView];
    
    CGFloat totalHeight = 0;
    CGFloat decidedWidth = 0;
    for (UIView *subView in chatBubbleContentView.subviews)
    {
        totalHeight += subView.frame.size.height;
        
        CGFloat width = subView.frame.size.width;
        if (decidedWidth < width)
            decidedWidth = width;
    }
    
    chatBubbleContentView.frame = CGRectMake(5, 5, decidedWidth, totalHeight);
    chatBubbleView.frame = CGRectMake(10, 10, chatBubbleContentView.frame.size.width+10, chatBubbleContentView.frame.size.height+10);
    
    if (isReceived == 0)
    {
        chatBubbleContentView.frame = CGRectMake(5, 5, decidedWidth, totalHeight);
        chatBubbleView.frame = CGRectMake(screenWidth-(chatBubbleContentView.frame.size.width+10)-10, 10, chatBubbleContentView.frame.size.width+10, chatBubbleContentView.frame.size.height+10);
        
        chatBubbleView.backgroundColor = Rgb2UIColor(220, 248, 193);
        chatTimeLabel.backgroundColor = Rgb2UIColor(220, 248, 193);
        chatBubbleLabel.backgroundColor = Rgb2UIColor(220, 248, 193);
        chatBubbleContentView.backgroundColor = Rgb2UIColor(220, 248, 193);
    }
    
    return chatBubbleView;
}

#pragma mark - Other functions

- (void)createExampleChat
{
    //Get screen width
    double screenWidth = self.view.frame.size.width;
    
    NSMutableArray *bubbles = [[NSMutableArray alloc] init];
    
    //Current date and time formatted string
    NSString *dateTimeString = [self getDateTimeStringFromNSDate:[NSDate date]];
    
    //Some custom hardcoded messages
    UIView *msg0 = [self createMessageWithScreenWidth:screenWidth Text:@"Hi!" Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg1 = [self createMessageWithScreenWidth:screenWidth Text:@"Hey, ssup ?" Image:nil DateTime:dateTimeString isReceived:0];
    UIView *msg2 = [self createMessageWithScreenWidth:screenWidth Text:@"Yeah uh huh you know what it iss...." Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg3 = [self createMessageWithScreenWidth:screenWidth Text:@"Black and yellow black and yellow black and yellow black and yellow" Image:[UIImage imageNamed:@"blackAndYellow.jpeg"] DateTime:dateTimeString isReceived:0];
    
    [bubbles addObject:msg0];
    [bubbles addObject:msg1];
    [bubbles addObject:msg2];
    [bubbles addObject:msg3];
    
    self.allMessages = bubbles;
    [self.chatTableView reloadData];
}

- (NSString*)getDateTimeStringFromNSDate: (NSDate*)date
{
    NSString *dateTimeString = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM, hh:mm a"];
    dateTimeString = [dateFormatter stringFromDate:date];
    
    return dateTimeString;
}


@end
