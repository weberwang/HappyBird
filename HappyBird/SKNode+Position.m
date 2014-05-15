//
//  SKNode+Position.m
//  HappyBird
//
//  Created by Minko on 14-5-13.
//  Copyright (c) 2014年 com.minko.bird. All rights reserved.
//

#import "SKNode+Position.h"

@implementation SKNode (Position)
-(void)setPositionX:(float)x
{
    [self setPosition:(CGPointMake(x, ([self getPositionY])))];
}

-(void)setPositionY:(float)y
{
    [self setPosition:(CGPointMake([self getPositionX], y))];
}

-(float)getPositionY
{
    return self.position.y;
}

-(float)getPositionX
{
    return self.position.x;
}
@end
