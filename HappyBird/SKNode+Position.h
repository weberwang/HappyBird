//
//  SKNode+Position.h
//  HappyBird
//
//  Created by Minko on 14-5-13.
//  Copyright (c) 2014年 com.minko.bird. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (Position)
-(void) setPositionX:(float) x;
-(void) setPositionY:(float) y;
-(float) getPositionX;
-(float) getPositionY;
@end
