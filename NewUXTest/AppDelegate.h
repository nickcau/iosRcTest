//
//  AppDelegate.h
//  NewUXTest
//
//  Created by 高友健 on 2017/4/8.
//  Copyright © 2017年 高友健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

