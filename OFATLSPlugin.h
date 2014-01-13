//
//  OFATLSPlugin.h
//  TestPhonegap
//
//  Created by Donald on 12/25/13.
//
//

#import <Cordova/CDVPlugin.h>
#import <ATLSClient/ATLSClient.h>

@interface STReceivedInfo : NSObject{
    NSString    *isState;
    NSDate  *receivedTime;
    NSString    *closestTag;
    NSString    *batteryLevel;
    NSString    *state;
    

    
}

@property (nonatomic, retain) NSString  *isState;
@property (nonatomic, retain) NSDate    *receviedTime;
@property (nonatomic, retain) NSString  *closestTag;
@property (nonatomic, retain) NSString  *batteryLevel;
@property (nonatomic, retain) NSString  *state;

@end

@interface OFATLSPlugin : CDVPlugin <ATLSClientDelegate>
{
    ATLSClient *atlsClient;
    
    NSString *closestTag;
    float batteryLevel;
    NSString *regionState;
    
    NSMutableArray  *receivedEvents;
    BOOL        isStartedReceiveEvents;
    NSTimer *timer;
}

- (void)initMembers;

- (void)changeBeacon:(CDVInvokedUrlCommand *)command;
- (void)startScanning:(CDVInvokedUrlCommand *)command;
- (void)stopScanning:(CDVInvokedUrlCommand *)command;
- (void)getValues:(CDVInvokedUrlCommand *)command;
- (void)getEvents:(CDVInvokedUrlCommand *)command;
- (void)startReceiveEvents:(CDVInvokedUrlCommand *)command;
- (void)stopReceiveEvents:(CDVInvokedUrlCommand *)command;

- (void)_startScanning:(NSString *)serverIp port:(NSString *)serverPort loginId:(NSString *)loginId password:(NSString *)loginPwd clientId:(NSString *)clientId usingBeacons:(BOOL)usingBeacons;
- (void)_stopScanning;
- (void)_changeBeacon:(BOOL)usingBeacons;

@end
