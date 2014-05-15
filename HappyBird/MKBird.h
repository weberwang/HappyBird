//
//  MKBird.h
//  HappyBird
//
//  Created by Minko on 14-5-13.
//  Copyright (c) 2014年 com.minko.bird. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
typedef enum
{
    BIRD_FLY = 0,
    BIRD_START,
    BIRD_UP,
    BIRD_OVER
} BIRD_STATE;
@interface MKBird : SKSpriteNode

+(MKBird*)bird;
-(void)changeState:(BIRD_STATE) state;
-(void)update:(NSTimeInterval)currentTime;
@end
