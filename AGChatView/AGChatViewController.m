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
@property (nonatomic) NSMutableArray *allMessages;
//Subview(s)
@property (nonatomic) UIView *viewBar;
@property (nonatomic) UITextView *messageTV;
@property (nonatomic) UIButton *sendButton;

@end

@implementation AGChatViewController

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Example title
    self.navigationItem.title = @"CJ";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.backgroundImageView.backgroundColor = Rgb2UIColor(211, 211, 211);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self createExampleChat];

    double screenWidth = self.view.frame.size.width;
    
    UIView *viewB = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, screenWidth+1, 50)];
    viewB.backgroundColor = [UIColor whiteColor];
    viewB.layer.borderWidth = 1.0;
    viewB.layer.borderColor = [Rgb2UIColor(204, 204, 204) CGColor];
    
    self.messageTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, screenWidth-80, 30)];
    self.messageTV.layer.cornerRadius = 5.0;
    self.messageTV.clipsToBounds = YES;
    self.messageTV.layer.borderColor = [[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor];
    self.messageTV.layer.borderWidth = 1.0;
    self.messageTV.font = [UIFont systemFontOfSize:16];
    self.messageTV.delegate = self;
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sendButton.frame = CGRectMake(screenWidth-70, 0, 70, 50);
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.messageTV];
    [viewB addSubview:self.sendButton];
    
    self.viewBar = viewB;
    
    [viewB addSubview:self.messageTV];
}

- (BOOL)canBecomeFirstResponder{
    
    return YES;
}

- (UIView *)inputAccessoryView{
    
    return self.viewBar;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.messageTV resignFirstResponder];
}

#pragma mark - Buttons' Actions

- (void)sendAction: (id)selector
{
    UIView *newMsg = [self createMessageWithText:self.messageTV.text Image:nil DateTime:[self getDateTimeStringFromNSDate:[NSDate date]] isReceived:0];

    [self.allMessages addObject:newMsg];
    [self.chatTableView reloadData];
    [self scrollToTheBottom:YES];
    
    [self.messageTV resignFirstResponder];
    self.messageTV.text = @"";
}

#pragma mark - Message UI creation function(s)

- (UIView*)createMessageWithText: (NSString*)text Image: (UIImage*)image DateTime: (NSString*)dateTimeString isReceived: (BOOL)isReceived
{
    //Get screen width
    double screenWidth = self.view.frame.size.width;

    CGFloat maxBubbleWidth = screenWidth-50;
    
    UIView *outerView = [[UIView alloc] init];
    
    UIView *chatBubbleView = [[UIView alloc] init];
    chatBubbleView.backgroundColor = [UIColor whiteColor];
    chatBubbleView.layer.masksToBounds = YES;
    chatBubbleView.clipsToBounds = NO;
    chatBubbleView.layer.cornerRadius = 4;
    chatBubbleView.layer.shadowOffset = CGSizeMake(0, 0.7);
    chatBubbleView.layer.shadowRadius = 4;
    chatBubbleView.layer.shadowOpacity = 0.4;
    
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
    
    outerView.frame = CGRectMake(7, 0, chatBubbleView.frame.size.width, chatBubbleView.frame.size.height);
    
    UIImageView *arrowIV = [[UIImageView alloc] init];
    [outerView addSubview:chatBubbleView];
    arrowIV.image = [UIImage imageNamed:@"chat_arrow"];
    arrowIV.clipsToBounds = NO;
    arrowIV.layer.shadowRadius = 4;
    arrowIV.layer.shadowOpacity = 0.4;
    arrowIV.layer.shadowOffset = CGSizeMake(-7.0, 0.7);
    arrowIV.layer.zPosition = 1;
    arrowIV.frame = CGRectMake(chatBubbleView.frame.origin.x-7, chatBubbleView.frame.size.height-10, 11, 14);

    if (isReceived == 0)
    {
        chatBubbleContentView.frame = CGRectMake(5, 5, decidedWidth, totalHeight);
        chatBubbleView.frame = CGRectMake(screenWidth-(chatBubbleContentView.frame.size.width+10)-10, 10, chatBubbleContentView.frame.size.width+10, chatBubbleContentView.frame.size.height+10);
        
        /*
        chatBubbleView.backgroundColor = Rgb2UIColor(191,179,183);
        chatTimeLabel.backgroundColor = Rgb2UIColor(191,179,183);
        chatBubbleLabel.backgroundColor = Rgb2UIColor(191,179,183);
        chatBubbleContentView.backgroundColor = Rgb2UIColor(191,179,183);
        */
        
        arrowIV.transform = CGAffineTransformMakeScale(-1, 1);
        arrowIV.frame = CGRectMake(chatBubbleView.frame.origin.x+chatBubbleView.frame.size.width-4, chatBubbleView.frame.size.height-10, 11, 14);
        
        outerView.frame = CGRectMake(screenWidth-((screenWidth+chatBubbleView.frame.size.width)-chatBubbleView.frame.size.width)-7, 0, chatBubbleView.frame.size.width, chatBubbleView.frame.size.height);

        //arrowIV.image = [arrowIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //[arrowIV setTintColor:Rgb2UIColor(191,179,183)];
    }
    
    [outerView addSubview:arrowIV];
    
    return outerView;
}

#pragma mark - Other functions

- (void)createExampleChat
{
    NSMutableArray *bubbles = [[NSMutableArray alloc] init];
    
    //Current date and time formatted string
    NSString *dateTimeString = [self getDateTimeStringFromNSDate:[NSDate date]];
    
    //Some custom hardcoded messages
    //Example 1
    /*
    UIView *msg0 = [self createMessageWithScreenWidth:screenWidth Text:@"Hi!" Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg1 = [self createMessageWithScreenWidth:screenWidth Text:@"Hey, ssup ?" Image:nil DateTime:dateTimeString isReceived:0];
    UIView *msg2 = [self createMessageWithScreenWidth:screenWidth Text:@"Yeah uh huh you know what it iss...." Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg3 = [self createMessageWithScreenWidth:screenWidth Text:@"Black and yellow black and yellow black and yellow black and yellow" Image:[UIImage imageNamed:@"blackAndYellow.jpeg"] DateTime:dateTimeString isReceived:0];
    */
    
    //Example 2
    UIView *msg0 = [self createMessageWithText:@"Hey! Movie tonight?" Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg1 = [self createMessageWithText:@"Which?" Image:nil DateTime:dateTimeString isReceived:0];
    UIView *msg2 = [self createMessageWithText:@"Kung fu panda 3" Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg3 = [self createMessageWithText:@"I'm in." Image:nil DateTime:dateTimeString isReceived:0];
    UIView *msg4 = [self createMessageWithText:@"Great, i'll get the tickets." Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg5 = [self createMessageWithText:@"Anyways, what about that new job opening you told me about. Can i still apply ?" Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg6 = [self createMessageWithText:@"Just wondering..." Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg7 = [self createMessageWithText:@"Yes, you can. Let me refer you to my Manager." Image:nil DateTime:dateTimeString isReceived:0];
    UIView *msg8 = [self createMessageWithText:@"Thanks a lot dude !" Image:nil DateTime:dateTimeString isReceived:1];

    [bubbles addObject:msg0];
    [bubbles addObject:msg1];
    [bubbles addObject:msg2];
    [bubbles addObject:msg3];
    [bubbles addObject:msg4];
    [bubbles addObject:msg5];
    [bubbles addObject:msg6];
    [bubbles addObject:msg7];
    [bubbles addObject:msg8];
    
    //Populate data in the chat table
    self.allMessages = bubbles;
    [self.chatTableView reloadData];

    //Scroll the table to bottom
    [self scrollToTheBottom:NO];
}

- (void)scrollToTheBottom:(BOOL)animated
{
    if (self.allMessages.count>0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.allMessages.count-1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
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
