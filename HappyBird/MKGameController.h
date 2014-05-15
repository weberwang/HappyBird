//
//  MKGameController.h
//  HappyBird
//
//  Created by Minko on 14-5-13.
//  Copyright (c) 2014年 com.minko.bird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKMyScene.h"
@class MKBird;
@interface MKGameController : NSObject<GameDelegate>

-(MKGameController*)initWithNode:(MKMyScene*)scene;
@end
