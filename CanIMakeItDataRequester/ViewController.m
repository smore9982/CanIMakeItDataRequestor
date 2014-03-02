//
//  ViewController.m
//  CanIMakeItDataRequester
//
//  Created by More, Sameer on 3/2/14.
//  Copyright (c) 2014 More, Sameer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getDataButton;
@property NSURLConnection *connection;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (IBAction)getData:(id)sender {
    [self startReceive];
    
}

- (void)startReceive
// Starts a connection to download the current URL.
{
    NSString *urlStr = @"http://ec2-54-83-18-44.compute-1.amazonaws.com:8080/CanIMakeWebService/GetStops";
    BOOL  success;
    NSURL *url= [NSURL URLWithString:urlStr];
    NSURLRequest *request;
    
    request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError* error;
        NSString *responeStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(responeStr);
        /*NSArray* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        for (int i=0;i<jsonData.count; i++) {
            NSDictionary* stopDict= [jsonData objectAtIndex:i];
            
            NSString *stopName = [stopDict objectForKey:@"stop_name"];
        }*/
    }];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection{
    
}
@end
