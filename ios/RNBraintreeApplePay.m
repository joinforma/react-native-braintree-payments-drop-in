#import "RNBraintreeApplePay.h"
#import <React/RCTLog.h>

@implementation RNBraintreeApplePay

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(runApplePay:(NSString *)name location:(NSString *)location)
{
 RCTLogInfo(@"Func Testing %@ at %@", name, location);
}

@end
