//
//  ViewController.h
//  ReactiveObjC
//
//  Created by chaiweiwei on 2017/4/19.
//  Copyright © 2017年 chaiweiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ActionType) {
    ActionTypeSimply,
    ActionTypeFilterSimply,
    ActionTypeBinding,
    ActionTypeButtonPress,
    ActionTypeMap,
    ActionTypeFlattenMap,
    ActionTypeDeliverOn,
    ActionTypeSerial,
    ActionTypeSequence,
};

@interface ViewController : UIViewController

@property (nonatomic,assign) ActionType actionType;

@end
