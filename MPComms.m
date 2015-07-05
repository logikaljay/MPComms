#import "MPComms.h"

@implementation MPComms
NSMutableDictionary *commands;

-(id)init
{
    if (self = [super init]) {
        commands = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void)sendMessage:(NSNumber *)messageId toPort:(NSString *)port withData:(NSData *)data
{
    CFStringRef port_name = (__bridge CFStringRef)port;
    CFMessagePortRef mPort = CFMessagePortCreateRemote(kCFAllocatorDefault, port_name);
    if (mPort != nil) {
        CFDataRef response = NULL;
        CFMessagePortSendRequest(mPort, (SInt32)[messageId intValue], (__bridge CFDataRef)data, 1000, 1000, kCFRunLoopDefaultMode, &response);
    }
}

-(void)sendMessage:(NSNumber *)messageId toPort:(NSString *)port withDictionary:(NSDictionary *)data
{
    NSData *dict = [NSKeyedArchiver archivedDataWithRootObject:data];
    [self sendMessage:messageId toPort:port withData:dict];
}

CFDataRef message_callback(CFMessagePortRef local, SInt32 msgid, CFDataRef data, void *info)
{
    void (^cb)(NSNumber *, NSData*) = [commands objectForKey:[NSNumber numberWithInt:msgid]];
    if (cb != nil) {
        cb([NSNumber numberWithInt:msgid], (__bridge NSData*)data);
    }
    
    return NULL;
}

-(void)recvMessage:(NSNumber *)messageId fromPort:(NSString *)port withCallback:(void(^)(NSNumber *, NSData *))cb
{
    CFStringRef port_name = (__bridge CFStringRef)port;
    CFMessagePortRef mPort = CFMessagePortCreateLocal(kCFAllocatorDefault, port_name, &message_callback, NULL, NULL);
    CFMessagePortSetDispatchQueue(mPort, dispatch_get_main_queue());
    
    [commands setObject:cb forKey:messageId];
}

@end

