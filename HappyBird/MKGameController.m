//
//  MKGameController.m
//  HappyBird
//
//  Created by Minko on 14-5-13.
//  Copyright (c) 2014年 com.minko.bird. All rights reserved.
//

#import "MKGameController.h"
#import "MKBird.h"
#import "MKMyScene.h"

@interface MKGameController()
@property(nonatomic, weak) MKMyScene* myScene;
@end

@implementation MKGameController
{
    MKBird* pBird;
}

-(MKGameController*)initWithNode:(MKMyScene*)scene
{
    if(self = [super init])
    {
        self.myScene = scene;
        pBird = self.myScene.bird;
        return self;
    }
    return nil;
}

-(void)gameStart
{
    [pBird changeState:BIRD_START];
}

-(void)gamePlay
{
    [pBird changeState:BIRD_UP];
}
-(void)gameOver
{
    [pBird changeState:BIRD_OVER];
}
@end
