//
//  ATLSClient.h
//  ATLSClient
//
//  Created by Saurabh Bhargava on 9/18/12.
//  Copyright (c) 2012 Motorola Solutions Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Foundation/NSString.h>
#import <CoreLocation/CoreLocation.h>
#import "ATLSServerInfo.h"

/** Optional delegate methods for the ATLS Client.
 *
 * Use these methods to receive extra information from the ATLS Client.
 */
@protocol ATLSClientDelegate <NSObject>
@optional

/**
 *  @method ATLSClient:StrongestTag:
 *
 *  @param client       The object sending the message
 *  @param tag          The name of the strongest tag
 *  @param RSSI         RSSI of the strongest tag
 *  @param batteryLife  Estimated percentage of remaining life in the tag's battery
 *
 *  @discussion     This method will be called at periodic intervals with the identity of the strongest tag.  The method will stop being called when there is no strongest tag identified.
 *
 */
- (void)ATLSClient:(id)client
      StrongestTag:(NSString *)tag
              RSSI:(NSNumber *)RSSI
       BatteryLife:(NSNumber *)batteryLife;

/**
 *  @method ATLSClient:didDetermineState:
 *
 *  @param client   The object sending the message
 *  @param state    This method will fire whenever the application crosses a border transition of an iBeacon region.  Even applications that are in the background will become active for a few seconds when a transition occurs.  For a list of possible values, see the CLRegionState type.
 *
 *  @discussion     This method is active only if the ATLSClient property usingIBeacons is set to YES.
 *
 */
- (void)ATLSClient:(id)client didDetermineState:(CLRegionState)state;
@end

/** This class is for sending ATLS position updates to the ATLS Server.
 
 Partner applications should integrate this interface into their customer applications.
 */

@interface ATLSClient : NSObject

/** Delegate for ATLSClient.
 
 See also ATLSClientDelegate.
 */
@property (nonatomic, weak) id <ATLSClientDelegate> delegate;

/** Network information about the ATLS Server.
 
 Refer to ATLSServerInfo.
 */
@property ATLSServerInfo* server;
/** The identity of this device.  The clientId will be sent to the ATLS Server with the position updates.
 
 @discussion    Set this property to nil if you are not connecting to an ATLS Server.
 */
@property NSString * clientId;
/** The location format being used by the ATLS tags.  Set this value to TRUE to indicate that the tags are generating iBeacons.
 */
@property (nonatomic, assign, getter=isUsingIBeacons) BOOL usingIBeacons;
/** A Dictionary containing the known attributes of the tag.  The key fields are:
 "tag"          The name of the strongest tag.
 "RSSI"         RSSI of the strongest tag
 "batteryLife"  Estimated percentage of remaining life in the tag's battery
 
 @discussion    The contents are volatile.  Use of a local variable is recommended in order to keep the data from changing while you're parsing the dictionary.  The property will be nil when there is no strongest tag identified.
 */
@property (nonatomic, readonly) NSDictionary *strongestTag;

/** Factory function for creating the ATLSClient object.
 
 @discussion  This function must be used to create the ATLSClient object.  Directly calling alloc and init on the ATLSClient class will result in a non-functional object.
 @return The ATLSClient object
 */
+ (id) initClient;

/** Start scanning for ATLS tags and send updates to the server.
 @return void
 */
- (void) Start;
/** Stop scanning for ATLS tags and stop updates to the server.
 @return void
 */
- (void) Stop;

@end
