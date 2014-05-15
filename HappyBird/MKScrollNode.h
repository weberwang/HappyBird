//
//  MKScrollNode.h
//  HappyBird
//
//  Created by Minko on 14-5-13.
//  Copyright (c) 2014年 com.minko.bird. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MKScrollNode : SKNode

@property(nonatomic, assign) float scrollSpeed;
-(void) updata:(NSTimeInterval)time;
+(MKScrollNode*)scrollWithName:(NSString*) name;

@property(nonatomic) CGSize size;
@end
