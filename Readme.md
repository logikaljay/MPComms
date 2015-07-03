# MPComms

## Use in a theos tool:

**Init the object**

    MPComms *comms = [[MPComms alloc] init];

**Setup the listener for messages on a port**

    [comms recvMessage:@2 fromPort:@"com.4o4.daemon" withCallback:^(NSNumber *msgId, NSData *data) {
        NSDictionary *result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }];

**Send a message to a port**

    [comms sendMessage:@1 toPort:@"com.4o4" withDictionary:@{ @"key": @"hello from the tool" }];

## Use in an Application:
If you don't add the entitlement `<key>com.apple.security.application-groups</key>` to your app then you will get the following error:
`*** CFMessagePort: bootstrap_register(): failed 1100 (0x44c) 'Permission denied', port = 0x4c07, name = 'com.4o4'
See /usr/include/servers/bootstrap_defs.h for the error codes.`

So to start:
1. edit your entitlements file - I use Jailcoder so:
   `sudo vi /Library/JailCoder/Entitlements/Entitlements.py`
2. Add the following as an entitlement 
        
        <key>com.apple.security.application-groups</key>
        <array>
            <string>com.4o4</string>
        </array>
        
3. If you have previousally built the app, you will need to clean the project and rebuild to use the new entitlements.
4. Then it is mostly the same as the theos tool:

**Init the object**

    MPComms *comms = [[MPComms alloc] init];

**Setup the listener for messages on a port**

    [comms recvMessage:@2 fromPort:@"com.4o4" withCallback:^(NSNumber *msgId, NSData *data) {
        NSDictionary *result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }];

**Send a message to a port**

    [comms sendMessage:@1 toPort:@"com.4o4.daemon" withDictionary:@{ @"key": @"hello from the app" }];