//
//  AGChatViewController.m
//  AGChatView
//
//  Created by Ashish Gogna on 09/04/16.
//  Copyright © 2016 Ashish Gogna. All rights reserved.
//

#import "AGChatViewController.h"
#import "AGMessageView.h"

@interface AGChatViewController ()

//All messages array (contains UIView instances)
@property (nonatomic) NSArray *allMessages;

@end

@implementation AGChatViewController

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Title";
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

    double screenWidth = self.view.frame.size.width;

    NSMutableArray *bubbles = [[NSMutableArray alloc] init];
    
    NSString *dateTimeString = [self getDateTimeStringFromNSDate:[NSDate date]];

    UIView *msg0 = [[AGMessageView alloc] createMessageWithScreenWidth:screenWidth Text:@"Hi!" Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg1 = [[AGMessageView alloc] createMessageWithScreenWidth:screenWidth Text:@"Hey, ssup ?" Image:nil DateTime:dateTimeString isReceived:0];
    UIView *msg2 = [[AGMessageView alloc] createMessageWithScreenWidth:screenWidth Text:@"Yeah uh huh you know what it iss...." Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg3 = [[AGMessageView alloc] createMessageWithScreenWidth:screenWidth Text:@"Black and yellow black and yellow black and yellow black and yellow" Image:[UIImage imageNamed:@"blackAndYellow.jpeg"] DateTime:dateTimeString isReceived:0];
    
    [bubbles addObject:msg0];
    [bubbles addObject:msg1];
    [bubbles addObject:msg2];
    [bubbles addObject:msg3];
    
    self.allMessages = bubbles;
    [self.chatTableView reloadData];
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

- (NSString*)getDateTimeStringFromNSDate: (NSDate*)date
{
    NSString *dateTimeString = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM, hh:mm a"];
    dateTimeString = [dateFormatter stringFromDate:date];
    
    return dateTimeString;
}

@end
