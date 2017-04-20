//
//  ViewController.m
//  ReactiveObjC
//
//  Created by chaiweiwei on 2017/4/19.
//  Copyright © 2017年 chaiweiwei. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
#import "NSString+Extend.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *comfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *isVaildButton;
@property (weak, nonatomic) IBOutlet UIImageView *userAvater;

@end

@implementation ViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isVaildButton.enabled = NO;
    
    switch (self.actionType) {
        case ActionTypeSimply:
        {
            [self addSimpleRAC];
        }
            break;
        case ActionTypeFilterSimply:{
            [self addFilterSimpleRAC];
        }
            break;
        case ActionTypeBinding:{
            [self addBindingRAC];
        }
            break;
        case ActionTypeButtonPress:{
            [self addButtonPressRAC];
        }
            break;
        case ActionTypeMap:{
            [self addMapRAC];
        }
            break;
        case ActionTypeFlattenMap:{
            [self addFlattenMapRAC];
        }
            break;
        case ActionTypeDeliverOn: {
            [self addDeliverOnRAC];
        }
            break;
        case ActionTypeSerial:{
            [self addSerialRAC];
        }
            break;
        case ActionTypeSequence:{
            [self addSequenceRAC];
        }
            break;
    }
}

#pragma mark - add Action

- (void)addSimpleRAC {
    [self.userName.rac_textSignal subscribeNext:^(NSString * _Nullable value) {
        NSLog(@"%@",value);
    }];
}

- (void)addFilterSimpleRAC {
    [[self.userName.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return [value containsString:@"RAC"];
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)addBindingRAC {
    RAC(self.isVaildButton, enabled) = [RACSignal combineLatest:@[self.password.rac_textSignal,self.comfirmPassword.rac_textSignal] reduce:^id (NSString *password, NSString *passwordConfirm){
        return @([password isEqualToString:passwordConfirm]);
    }];
}

- (void)addButtonPressRAC {
    self.isVaildButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"Buttpn press");
        //return [RACSignal empty];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"请求数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [self.isVaildButton.rac_command.executionSignals subscribeNext:^(RACSignal<id> * _Nullable x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
        [x subscribeCompleted:^{
            NSLog(@"finish");
        }];
    }];
}

- (void)addMapRAC {
    [[self.userName.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length);
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)addFlattenMapRAC {
    [[[self.userName.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 0;
    }] flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        //return new signal
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"发送请求"];
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)addDeliverOnRAC {
    RAC(self.userAvater,image) = [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"http://wx.qlogo.cn/mmopen/lz20TcpKLicdicyic4QM6FawkuJOdibLdialfxPjxiaARvfMUg2LibwEIlTvwTw1AzUkBnXiaQy1DoSXicobHbW5geJ4LQpc7A8f0Ocm4/0"];
        [subscriber sendCompleted];
        return nil;
    }] map:^id _Nullable(NSString * _Nullable url) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        return [[UIImage alloc] initWithData:data];
    }] deliverOn:RACScheduler.mainThreadScheduler];
}

- (void)addSerialRAC {
    [[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送请求"];
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal * _Nonnull{
        return [self loadCachedMessages];
    }] flattenMap:^__kindof RACSignal * _Nullable(NSArray * _Nullable value) {
        return [self fetchMessagesAfterMessage:value.lastObject];
    }] subscribeError:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    } completed:^{
       NSLog(@"Fetched all messages.");
    }];
}

- (RACSignal *)loadCachedMessages {
    RACSignal *loadCached = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSArray *messages = @[@"1",@"2",@"3"];
        [subscriber sendNext:messages];
        [subscriber sendCompleted];
        return nil;
    }];
    return loadCached;
}

- (RACSignal *)fetchMessagesAfterMessage:(NSString *)message {
    RACSignal *fetchMessages = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if(message.length > 0) {
            [subscriber sendCompleted];
        }else {
            NSError *error = [[NSError alloc] initWithDomain:@"signal" code:100 userInfo:nil];
            [subscriber sendError:error];
        }
        return nil;
    }];
    return fetchMessages;
}

- (void)addSequenceRAC {
    NSArray *strings = @[@"1",@"345",@"6",@"7890"];
    RACSequence *results = [[strings.rac_sequence filter:^BOOL(NSString * _Nullable value) {
        return (value.length > 2);
    }] map:^id _Nullable(NSString * _Nullable value) {
        return [value stringByAppendingFormat:@"footer"];
    }];
    NSLog(@"%@",results.array);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
