//
//  AppDelegate.h
//  ReactiveObjC
//
//  Created by chaiweiwei on 2017/4/19.
//  Copyright © 2017年 chaiweiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

