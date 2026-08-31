#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface DemoRequest : NSObject
@property (nonatomic, copy) NSString *endpoint;
@end
@implementation DemoRequest
@end

@interface DemoTraceContext : NSObject
@property (nonatomic, copy) NSString *requestID;
@property (nonatomic, strong) NSDate *startedAt;
- (instancetype)initWithRequestID:(NSString *)requestID;
@end

@implementation DemoTraceContext
- (instancetype)initWithRequestID:(NSString *)requestID {
    self = [super init];
    if (self) {
        _requestID = [requestID copy];
        _startedAt = [NSDate date];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"Trace context released: %@", _requestID);
}
@end

@interface DemoRequest (TraceContext)
@property (nonatomic, strong, nullable) DemoTraceContext *demo_traceContext;
@property (nonatomic, copy, nullable) NSString *demo_displayLabel;
@end

@implementation DemoRequest (TraceContext)
static const void *DemoTraceContextKey = &DemoTraceContextKey;
static const void *DemoDisplayLabelKey = &DemoDisplayLabelKey;

- (void)setDemo_traceContext:(DemoTraceContext *)context {
    objc_setAssociatedObject(self, DemoTraceContextKey, context,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (DemoTraceContext *)demo_traceContext {
    return objc_getAssociatedObject(self, DemoTraceContextKey);
}
- (void)setDemo_displayLabel:(NSString *)label {
    objc_setAssociatedObject(self, DemoDisplayLabelKey, label,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)demo_displayLabel {
    return objc_getAssociatedObject(self, DemoDisplayLabelKey);
}
@end

int main(void) {
    @autoreleasepool {
        __weak DemoTraceContext *weakContext = nil;
        @autoreleasepool {
            DemoRequest *request = [DemoRequest new];
            request.endpoint = @"/catalog";

            DemoTraceContext *context = [[DemoTraceContext alloc]
                initWithRequestID:@"req-2026-0907"];
            weakContext = context;
            request.demo_traceContext = context;

            NSMutableString *label = [@"Catalog request" mutableCopy];
            request.demo_displayLabel = label;
            [label appendString:@" (mutated outside)"];

            NSLog(@"%@ -> %@", request.demo_displayLabel,
                  request.demo_traceContext.requestID);
            NSLog(@"Copy policy preserved label: %@",
                  [request.demo_displayLabel isEqualToString:@"Catalog request"] ? @"PASS" : @"FAIL");
        }
        NSLog(@"Owner lifecycle released context: %@", weakContext == nil ? @"PASS" : @"FAIL");
    }
    return 0;
}
