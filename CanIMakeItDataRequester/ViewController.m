//
//  ViewController.m
//  CanIMakeItDataRequester
//
//  Created by More, Sameer on 3/2/14.
//  Copyright (c) 2014 More, Sameer. All rights reserved.
//

#import "ViewController.h"
#import "StopModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getDataButton;
@property (weak, nonatomic) IBOutlet UITextView *textBox;
@property NSURLConnection *connection;
@property NSMutableArray *stops;
@property (weak, nonatomic) IBOutlet UITextView *stopTextBox;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stops = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)getData:(id)sender {
    [self startGetStopsRequest];
    [self.textBox setText:@"Getting stops"];
}

- (void)startGetStopsRequest
{
    //Url of web service.
    NSString *urlStr = @"http://ec2-54-83-18-44.compute-1.amazonaws.com:8080/CanIMakeWebService/GetStops";
    NSURL *url= [NSURL URLWithString:urlStr];
    NSURLRequest *request;
    
    request = [NSURLRequest requestWithURL:url];
    //Send an asyncronous request to get data from url.
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showStopsError:connectionError];
            });
        }else{
            //Use this to run on UI Thread from a background thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showStopsResponse:data];
            });
        }
    }];
}

-(void) loadStopData{
    NSString* stopList = @"";
    for(int i=0; i<[self.stops count];i++){
        StopModel* model = [self.stops objectAtIndex:i];
        NSString* str = [NSString stringWithFormat:@"Stop Id: %@ , Stop Name: %@\n",model.stopId,model.stopName];
        //String you concatenating to cannot be nil. Otherwise it won't work.
        stopList = [stopList stringByAppendingString:str];
    }
    [self.stopTextBox setText:stopList];
}

-(void)showStopsResponse:(NSData*) responseData{
    NSError* error;
    //Add the response to the top text box.
    NSString *responeStr=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    [self.textBox setText:responeStr];
    
    //Do json desrialization on data
    NSArray* stopsArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    //Iterate over array and parse json data
    for(int i=0;i<[stopsArray count];i++){
        //Each array object can be put into NSDictionary.
        NSDictionary* stopData = [stopsArray objectAtIndex:i];
        NSString* stopId = [stopData valueForKey:@"id"];
        NSString* stopName = [stopData valueForKey:@"name"];
        StopModel* stopModel = [[StopModel alloc]init];
        stopModel.stopId = stopId;
        stopModel.stopName = stopName;
        [self.stops addObject:stopModel];
    }
    [self loadStopData];
}

-(void)showStopsError:(NSError*) error{
    [self.textBox setText:@"There was an issued getting stops"];
}
@end
