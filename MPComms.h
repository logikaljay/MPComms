#import <Foundation/Foundation.h>

@interface MPComms : NSObject
-(void)sendMessage:(NSNumber *)messageId toPort:(NSString *)port withData:(NSData *)data;
-(void)sendMessage:(NSNumber *)messageId toPort:(NSString *)port withDictionary:(NSDictionary *)data;
-(void)recvMessage:(NSNumber *)messageId fromPort:(NSString *)port withCallback:(void(^)(NSNumber *, NSData *))cb;
@end
