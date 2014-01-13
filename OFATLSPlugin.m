//
//  OFATLSPlugin.m
//  TestPhonegap
//
//  Created by Donald on 12/25/13.
//
//

#import "OFATLSPlugin.h"
#import <Cordova/CDV.h>

@implementation STReceivedInfo

@synthesize receviedTime;
@synthesize closestTag;
@synthesize batteryLevel;
@synthesize isState;
@synthesize state;

@end

@implementation OFATLSPlugin

+ (NSString*) getTimeString : (NSDate *)date
{
    //NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
   // if ( fmt == nil ) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //} else {
     //   [dateFormatter setDateFormat:fmt];
    //}
    
    return [dateFormatter stringFromDate:date];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self initMembers];
    }
    return self;
}

- (void)initMembers
{
    closestTag = @"";
    batteryLevel = 0.f;
    regionState = @"";
    
}

// is called when user click start scanning checkbox with checked status.
- (void)startScanning:(CDVInvokedUrlCommand *)command
{
    //console.log(@"startScanning --");
    
    //[self initMembers];
    CDVPluginResult *pluginResult = nil;
    NSString *resultJS = nil;
    
    if (command.arguments.count < 6)
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Argument was not valid"];
        resultJS = [pluginResult toErrorCallbackString:command.callbackId];
        [self writeJavascript:resultJS];
        return;
    }
    
    // get parameters from argument.
    NSString *serverIp = [command.arguments objectAtIndex:0];
    NSString *serverPort = [command.arguments objectAtIndex:1];
    NSString *loginId = [command.arguments objectAtIndex:2];
    NSString *loginPwd = [command.arguments objectAtIndex:3];
    NSString *clientId = [command.arguments objectAtIndex:4];
    NSString *strBeacon = [command.arguments objectAtIndex:5];
    BOOL usingBeacon = TRUE;
    if ([strBeacon isEqualToString:@"false"]) {
        usingBeacon = FALSE;
    }
    
    [self _startScanning:serverIp port:serverPort loginId:loginId password:loginPwd clientId:clientId usingBeacons:usingBeacon];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    resultJS = [pluginResult toSuccessCallbackString:command.callbackId];
    [self writeJavascript:resultJS];
    
    //for debuggin
    //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(targetMethod:) userInfo:nil repeats:NO];
}

//- (void)targetMethod:(NSTimer*)timer
//{
//    [self.webView stringByEvaluatingJavaScriptFromString:@"didDetermineState()"];
//}

- (void)targetMethod:(NSTimer*)timer
{
    STReceivedInfo *info = [[STReceivedInfo alloc] init];
    info.isState = @"false";
    info.receviedTime = [NSDate date];
    info.closestTag = @"tag";
    info.batteryLevel = [NSString stringWithFormat:@"%f", 3.4234];
    info.state = @"";
    if (receivedEvents == nil)
        receivedEvents = [[NSMutableArray alloc] init];
    if (receivedEvents.count >= 100) {
        [receivedEvents removeObjectAtIndex:0];
    }
    [receivedEvents addObject:info];
    if (isStartedReceiveEvents == NO) {
        return;
    }
    [self.webView stringByEvaluatingJavaScriptFromString:@"onConstructor()"];
}

// is called when user click start scanning checkbox with unchecked status.
- (void)stopScanning:(CDVInvokedUrlCommand *)command
{
    //console.log(@"stopScanning---");
    
    CDVPluginResult *pluginResult = nil;
    NSString *resultJS = nil;
    
    [self _stopScanning];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    resultJS = [pluginResult toSuccessCallbackString:command.callbackId];
    [self writeJavascript:resultJS];
}

- (void)changeBeacon:(CDVInvokedUrlCommand *)command
{
    //console.log(@"changeBeacon----");
    
    CDVPluginResult *pluginResult = nil;
    NSString *resultJS = nil;
    
    NSString *strBeacon = [command.arguments objectAtIndex:0];
    if (strBeacon == nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Argument was not valid"];
        resultJS = [pluginResult toErrorCallbackString:command.callbackId];
        [self writeJavascript:resultJS];
        return;
    }
    
    BOOL usingBeacons = TRUE;
    if ([strBeacon isEqualToString:@"false"]) {
        usingBeacons = FALSE;
    }
    
    [self _changeBeacon:usingBeacons];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    resultJS = [pluginResult toSuccessCallbackString:command.callbackId];
    [self writeJavascript:resultJS];
}

- (void)startReceiveEvents:(CDVInvokedUrlCommand *)command
{
 
    CDVPluginResult *pluginResult = nil;
    NSString *resultJS = nil;
    
    if (isStartedReceiveEvents == YES) {
        return;
    }
    if (receivedEvents == nil)
        receivedEvents = [[NSMutableArray alloc] init];
    
    isStartedReceiveEvents = YES;
    //for debugging
    //timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(targetMethod:) userInfo:nil repeats:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    resultJS = [pluginResult toSuccessCallbackString:command.callbackId];
    [self writeJavascript:resultJS];
}

- (void)stopReceiveEvents:(CDVInvokedUrlCommand *)command
{
    
    CDVPluginResult *pluginResult = nil;
    NSString *resultJS = nil;
    
    if (isStartedReceiveEvents == YES) {
        isStartedReceiveEvents = NO;
        if (timer != nil)
            [timer invalidate];
        timer = nil;
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    resultJS = [pluginResult toSuccessCallbackString:command.callbackId];
    [self writeJavascript:resultJS];
}

- (void)getValues:(CDVInvokedUrlCommand *)command
{
    //console.log(@"get values------");
    
    //[self initMembers];
    CDVPluginResult *pluginResult = nil;
    NSString *resultJS = nil;
    
    NSMutableDictionary* retValues = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [retValues setObject:closestTag forKey:@"closestTag"];
    [retValues setObject:[NSString stringWithFormat:@"%f", batteryLevel] forKey:@"batteryLevel"];
    [retValues setObject:regionState forKey:@"regionState"];
    
    //NSString *strRetParam = [retValues JSONString];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:retValues];
    resultJS = [pluginResult toSuccessCallbackString:command.callbackId];
    [self writeJavascript:resultJS];
}


- (void)getEvents:(CDVInvokedUrlCommand *)command
{
    
    CDVPluginResult *pluginResult = nil;
    NSString *resultJS = nil;
    
    NSMutableDictionary* retValues = [NSMutableDictionary dictionaryWithCapacity:100];
    if (receivedEvents == nil)
        receivedEvents = [[NSMutableArray alloc] init];
    for (int i = 0; i < receivedEvents.count; i++) {
        STReceivedInfo *info = (STReceivedInfo *)[receivedEvents objectAtIndex:i];
        NSMutableDictionary* items = [NSMutableDictionary dictionaryWithCapacity:5];
        [items setObject:info.isState forKey:@"isState"];
        [items setObject:[OFATLSPlugin getTimeString:info.receviedTime] forKey:@"receivedTime"];
        [items setObject:info.closestTag forKey:@"closetTag"];
        [items setObject:info.batteryLevel forKey:@"batteryLevel"];
        [items setObject:info.state forKey:@"state"];
        [retValues setObject:items forKey:[NSString stringWithFormat:@"%d", i]];
    }
    [retValues setObject:[NSString stringWithFormat:@"%d", receivedEvents.count] forKey:@"length"];
    
    //NSString *strRetParam = [retValues JSONString];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:retValues];
    /*resultJS = */[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    //resultJS = [pluginResult toSuccessCallbackString:command.callbackId];
    //[self writeJavascript:resultJS];
}


#pragma mark ATLSClient Delegate Methods -
- (void)ATLSClient:(id)client
      StrongestTag:(NSString *)tag
              RSSI:(NSNumber *)RSSI
       BatteryLife:(NSNumber *)batteryLife
{
    closestTag = tag;
    batteryLevel = batteryLife.floatValue;
    
    STReceivedInfo *info = [[STReceivedInfo alloc] init];
    info.isState = @"false";
    info.receviedTime = [NSDate date];
    info.closestTag = tag;
    info.batteryLevel = [NSString stringWithFormat:@"%f", batteryLife.floatValue];
    info.state = @"";
    
    if (receivedEvents == nil)
        receivedEvents = [[NSMutableArray alloc] init];
    if (receivedEvents.count >= 100) {
        [receivedEvents removeObjectAtIndex:0];
    }
    [receivedEvents addObject:info];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"onConstructor()"];
}

- (void)ATLSClient:(id)client didDetermineState:(CLRegionState)state
{
    
    switch (state) {
        case CLRegionStateInside:
            regionState = @"Inside";
            break;
            
        case CLRegionStateOutside:
            regionState = @"Outside";
            break;
            
        default:
            regionState = @"Unknown";
            break;
    }
    
    STReceivedInfo *info = [[STReceivedInfo alloc] init];
    info.isState = @"true";
    info.receviedTime = [NSDate date];
    info.closestTag = @"";
    info.batteryLevel = @"";
    info.state = regionState;
    if (receivedEvents == nil)
        receivedEvents = [[NSMutableArray alloc] init];
    if (receivedEvents.count >= 100) {
        [receivedEvents removeObjectAtIndex:0];
    }
    [receivedEvents addObject:info];

    
    [self.webView stringByEvaluatingJavaScriptFromString:@"didDetermineState()"];
    
}


- (void)_startScanning:(NSString *)serverIp port:(NSString *)serverPort loginId:(NSString *)loginId password:(NSString *)loginPwd clientId:(NSString *)clientId usingBeacons:(BOOL)usingBeacons {
    
    
    // Use the initClient method to create an instance of the ATLSClient.
    // Do not call the allocate method directly.
    atlsClient = [ATLSClient initClient];
    
    // Optional: Setup the delegate if you want the app to be informed of events
    atlsClient.delegate = self;
    
    // Optional: Setup the ATLS server information
    if([serverIp length])
    {
        atlsClient.server = [[ATLSServerInfo alloc] initWithNetwork:serverIp AndPort:[serverPort intValue]];
        atlsClient.server.loginID = loginId;
        atlsClient.server.password = loginPwd;
        atlsClient.clientId = clientId;
    } else {
        atlsClient.server = nil;
    }
    
    // Tell the library which beacon format is being used
    atlsClient.usingIBeacons = usingBeacons;
    
    // Initialize the output values
    [self initMembers];
    
    // Start processing ATLS tags
    [atlsClient Start];
    
}

- (void)_stopScanning {
    [atlsClient Stop];
    atlsClient = nil;
}

- (void)_changeBeacon:(BOOL)usingBeacons {
    if (atlsClient) {
        // Changing this value while the ATLS Client is running
        // may result in a delay while the library refereshes its data.
        [self initMembers];
        atlsClient.usingIBeacons = usingBeacons;
    }
}

@end
