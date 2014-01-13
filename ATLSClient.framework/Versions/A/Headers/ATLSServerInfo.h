//
//  ATLSServerInfo.h
//  ATLSClient
//
//  Created by Saurabh Bhargava on 9/18/12.
//  Copyright (c) 2012 Motorola Solutions Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/** This class holds the network information relevant to the ATLS server.
 
 Refer to ATLSClient
 */

@interface ATLSServerInfo : NSObject

/** IP address of the ATLS Server
 */
@property NSString* host;
/** Port number of the ATLS Server
 */
@property short port;
/** Login user name that will gain access to the ATLS Server
 */
@property NSString* loginID;
/** Login password to the ATLS Server
 */
@property NSString* password;

/** Convenience method for creating an ATLSServerInfo object.
 
 @param host IP address of the ATLS Server
 @param port Port number of the ATLS Server
 @return An ATLSServerInfo object initialized with the input host and port
 */
-(id) initWithNetwork: (NSString *)host AndPort: (unsigned short)port;

@end

