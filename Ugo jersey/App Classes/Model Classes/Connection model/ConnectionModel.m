//
//  Connection Model.m
//  Ugo jersey
//
//  Created by Debasish Pal on 09/08/13.
//  Copyright (c) 2013 Debasish Pal. All rights reserved.
//

#import "ConnectionModel.h"
#import "Constant.h"

@implementation ConnectionModel

@synthesize delegate,request;

-(ASIFormDataRequest*)initiateRequestWithURL:(NSURL*)url
{
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
    [_request setUseKeychainPersistence:YES];
    [_request setTimeOutSeconds:60];
    [_request setDelegate:self];
    _request.shouldAttemptPersistentConnection   = NO;
    return _request;
}
-(void)startResquestForLogin:(NSMutableDictionary*)dict
{
    NSString *tmpStr = [[NSString alloc] initWithFormat:BASE_URL];
    NSURL *url = [NSURL  URLWithString:[tmpStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"requrl: %@",url);
    [tmpStr release];
    
    self.request = [self initiateRequestWithURL:url];
    [self.request setPostValue:[dict objectForKey:@"action"] forKey:@"action"];
    [self.request setPostValue:[dict objectForKey:@"user_id"] forKey:@"user_id"];
    [self.request setPostValue:[dict objectForKey:@"password"] forKey:@"password"];
    [request setUsername:@"login"];
    [self.request startAsynchronous];
}

-(void)startResquestForFBLogin:(NSMutableDictionary*)dict
{
    NSString *tmpStr = [[NSString alloc] initWithFormat:BASE_URL];
    NSURL *url = [NSURL  URLWithString:[tmpStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"requrl: %@",url);
    [tmpStr release];
    
    self.request = [self initiateRequestWithURL:url];
    [self.request setPostValue:[dict objectForKey:@"action"] forKey:@"action"];
    [self.request setPostValue:[dict objectForKey:@"user_email"] forKey:@"user_email"];
    [self.request setPostValue:[dict objectForKey:@"name"] forKey:@"name"];
    [request setUsername:@"fblogin"];
    [self.request startAsynchronous];
}

-(void)startResquestForupdateTicketStatus:(NSMutableDictionary*)dict
{
    NSString *tmpStr = [[NSString alloc] initWithFormat:BASE_URL];
    NSURL *url = [NSURL  URLWithString:[tmpStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"requrl: %@",url);
    [tmpStr release];
    
    self.request = [self initiateRequestWithURL:url];
    [self.request setPostValue:[dict objectForKey:@"action"] forKey:@"action"];
    [self.request setPostValue:[dict objectForKey:@"ticket_id"] forKey:@"ticket_id"];
    [request setUsername:@"updateTicketStatus"];
    [self.request startAsynchronous];
}

-(void)startResquestForLogout:(NSMutableDictionary*)dict:(id)jsonArr
{
    NSString *tmpStr = [[NSString alloc] initWithFormat:BASE_URL];
    NSURL *url = [NSURL  URLWithString:[tmpStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"requrl: %@",url);
    [tmpStr release];
    
    self.request = [self initiateRequestWithURL:url];
    [self.request setPostValue:[dict objectForKey:@"action"] forKey:@"action"];
    [self.request setPostValue:[dict objectForKey:@"user_id"] forKey:@"user_id"];
    [self.request setPostValue:[dict objectForKey:@"password"] forKey:@"password"];
    [self.request addPostValue:jsonArr forKey:@"ticket_array"];
    [request setUsername:@"logout"];
    
    [self.request startAsynchronous];
}
#pragma mark - ASIFormDataRequest delegates
-(void)receivedData:(ASIHTTPRequest*) response
{
    NSLog(@"Received data");
}
- (void)requestFinished:(ASIHTTPRequest *)response
{
    [self.delegate connectionDidReceiveResponse:response];
    self.request = nil;
}
- (void)requestFailed:(ASIHTTPRequest *)response
{
    [self.delegate connectionDidFailedResponse:response];
    self.request = nil;
    
    NSLog(@"Conection failed");
}
@end

