#import "MPComms.h"

@implementation MPComms
void (^callback)(NSNumber *, NSData*);

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
    callback([NSNumber numberWithInt:msgid], (__bridge NSData*)data);
    return NULL;
}

-(void)recvMessage:(NSNumber *)messageId fromPort:(NSString *)port withCallback:(void(^)(NSNumber *, NSData *))cb
{
    callback = cb;
    CFStringRef port_name = (__bridge CFStringRef)port;
    CFMessagePortRef mPort = CFMessagePortCreateLocal(kCFAllocatorDefault, port_name, &message_callback, NULL, NULL);
    CFMessagePortSetDispatchQueue(mPort, dispatch_get_main_queue());
}

@end

