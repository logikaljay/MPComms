# MPComms

## Use in a theos tool

### Init the object

    MPComms *comms = [[MPComms alloc] init];

### Setup the listener for messages on a port

    [comms recvMessage:@2 fromPort:@"com.4o4.daemon" withCallback:^(NSNumber *msgId, NSData *data) {
        NSDictionary *result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }];

### Send a message to a port

    [comms sendMessage:@1 toPort:@"com.4o4" withDictionary:@{ @"key": @"hello from shitpissfuckcunt" }];
