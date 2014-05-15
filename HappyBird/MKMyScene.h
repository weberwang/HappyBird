//
//  MKMyScene.h
//  HappyBird
//

//  Copyright (c) 2014年 com.minko.bird. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class MKBird;
@protocol GameDelegate <NSObject>

-(void)gameStart;
-(void)gameOver;
-(void)gamePlay;

@end

@interface MKMyScene : SKScene<SKPhysicsContactDelegate>

@property(nonatomic) MKBird* bird;
@end
