#import "RNBraintree.h"
#import "BraintreeCore.h"
#import "BTCardClient.h"
#import "BTCard.h"
#import "BraintreePayPal.h"
#import "BTDataCollector.h"
#import "BTCardNonce.h"
#import "BTPaymentMethodNonce.h"
#import "BraintreePaymentFlow.h"
#import <React/RCTLog.h>


@interface RNBraintree()
@property (nonatomic, strong) BTAPIClient *apiClient;
@property (nonatomic, strong) BTDataCollector *dataCollector;
@end

@implementation RNBraintree

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(printMe:(NSString *)name location:(NSString *)location)
{
 RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
}

RCT_EXPORT_METHOD(fetchPaymentMethodNonces: (NSDictionary *)parameters
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject) {

    NSString *clientToken = parameters[@"clientToken"];
    self.apiClient = [[BTAPIClient alloc] initWithAuthorization: clientToken];
    self.dataCollector = [[BTDataCollector alloc] initWithAPIClient:self.apiClient];
    
    [self.apiClient fetchPaymentMethodNonces:^(NSArray<BTPaymentMethodNonce *> * _Nullable paymentMethodNonces, NSError * _Nullable error)
        {
            if (error) {
                reject(@"error", error.description, nil);
                return;
            }
            NSMutableArray *data = [[NSMutableArray alloc] init];
            if(paymentMethodNonces.count > 0) {
                for (BTPaymentMethodNonce *nonceItem in paymentMethodNonces) {
                    BTCardNonce *cardNonce = (BTCardNonce*)nonceItem;
                    [data addObject:@{ 
                        @"nonce": nonceItem.nonce, 
                        @"type": nonceItem.type,
                        @"lastTwo": cardNonce.lastTwo, 
                        @"isDefault": nonceItem.isDefault? @"yes":@"no" }];
                }
                
            }
            resolve(@{@"nonces": data});
        }
    ];
}

RCT_EXPORT_METHOD(tokenizeCard: (NSDictionary *)parameters
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject) {

    NSString *clientToken = parameters[@"clientToken"];
    self.apiClient = [[BTAPIClient alloc] initWithAuthorization: clientToken];
    self.dataCollector = [[BTDataCollector alloc] initWithAPIClient:self.apiClient];
    BTCardClient *cardClient = [[BTCardClient alloc] initWithAPIClient: self.apiClient];

    BTCard *card = [BTCard new];
    
    card.number = parameters[@"number"];
    card.expirationMonth = parameters[@"expirationMonth"];
    card.expirationYear = parameters[@"expirationYear"];
    card.cvv = parameters[@"cvv"];
    NSString* postalCode = parameters[@"postalCode"];
    if(postalCode){
        card.postalCode = parameters[@"postalCode"];
    }
    card.shouldValidate = YES;
    
    [cardClient tokenizeCard:card completion:^(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error) {
        if (error) {
            reject(@"TOKENIZE_FAILED", error.localizedDescription, nil);
            return;
        }
        resolve(@{@"nonce": tokenizedCard.nonce});
    }];
}
@end
