//
//  MKScrollNode.m
//  HappyBird
//
//  Created by Minko on 14-5-13.
//  Copyright (c) 2014年 com.minko.bird. All rights reserved.
//

#import "MKScrollNode.h"
#import "SKNode+Position.h"
#import "SKTextureAtlas+TextureCache.h"

NSString* NAME_FIRST = @"first";
NSString* NAME_NEXT = @"next";
@implementation MKScrollNode
{
    SKSpriteNode* first;
    SKSpriteNode* next;
}

+(MKScrollNode*)scrollWithName:(NSString *)name
{
    return [[self alloc] initWithName:name];
}

-(id)initWithName:(NSString*) name
{
    if(self = [super init])
    {
        SKTexture* texture = [[SKTextureAtlas getTexureCache] textureNamed:name];
        first = [SKSpriteNode spriteNodeWithTexture:texture];
        first.name = NAME_FIRST;
        [first setAnchorPoint:CGPointZero];
        next = [SKSpriteNode spriteNodeWithTexture:texture];
        next.name = NAME_NEXT;
        [next setAnchorPoint:CGPointZero];
        [next setPositionX:([first getPositionX] + first.size.width)];
        [self addChild:first];
        [self addChild:next];
        _size = CGSizeMake(texture.size.width * 2, texture.size.height);
        return self;
    }
    else
    {
        return nil;
    }
}

-(void)updata:(NSTimeInterval)time
{
    float nextX = [self getPositionX] + self.scrollSpeed;
    [self setPositionX:nextX];
    CGPoint firstPointInWorld = [self convertPoint:first.position toNode:self.parent];
    if(firstPointInWorld.x  < -first.size.width)
    {
        [first setPositionX:([next getPositionX] + next.size.width)];
    }
    CGPoint nextPointInWorld = [self convertPoint:next.position toNode:self.parent];
    if(nextPointInWorld.x  < -next.size.width)
    {
        [next setPositionX:([first getPositionX] + next.size.width)];
    }
}

@end
