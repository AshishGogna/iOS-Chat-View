# iOS-Chat-View
####AGChatView
Plug and Play Chat UI for iOS, written in Objective C. 
Highly customizable
Easy to use

######Screenshots
![alt text](http://i.imgur.com/mnYoiVo.jpg "Screenshot 0")
![alt text](http://i.imgur.com/t4l3TsT.jpg "Screenshot 1")

###How to integrate with a project ?
1. Clone the repo.
2. Drag and drop AGChatViewController.h, AGChatViewController.m and AGChatViewController.xib, chat_arrow.png, chat_arrow.png@2x, chat_arrow.png@3x from /AGChatView/ into your xcode project directory.

###How to use ?
Use AGViewController class as your chat view controller class.

Example code - 


```

//Get screen width
double screenWidth = self.view.frame.size.width;

NSMutableArray *bubbles = [[NSMutableArray alloc] init];

//Current date and time formatted string. Below line gets the current date
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

//Populate data in the chat table
self.allMessages = bubbles;
[self.chatTableView reloadData];

//Scroll the table to bottom
[self scrollToTheBottom:NO];

```

