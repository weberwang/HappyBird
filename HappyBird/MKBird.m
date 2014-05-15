//
//  MKBird.m
//  HappyBird
//
//  Created by Minko on 14-5-13.
//  Copyright (c) 2014年 com.minko.bird. All rights reserved.
//

#import "MKBird.h"
#import "SKTextureAtlas+TextureCache.h"
#import "SKNode+Position.h"
#import "MKMask.h"

@implementation MKBird
{
    SKAction* upSound;
    SKAction* overSound;
}

const int BIRD_COUNT = 3;
const float VERTICAL_DELTA = 5.0;
const float VERTICAL_SPEED = 1.0;

+(MKBird *)bird
{
    SKTexture* birdTexture = [[SKTextureAtlas getTexureCache] textureNamed:@"bird_1"];
    return [[self alloc]initWithTexture:birdTexture];
}

-(id)initWithTexture:(SKTexture *)texture
{
    if((self = [super initWithTexture:texture]))
    {
        return self;
    }
    else
    {
        return nil;
    }
}

-(void)changeState:(BIRD_STATE)state
{
    switch (state) {
        case BIRD_FLY:
            [self fly];
            break;
        case BIRD_START:
            [self startFly];
            break;
        case BIRD_UP:
            [self flyUp];
            break;
        case BIRD_OVER:
            [self over];
            break;
        default:
            break;
    }
}
-(void)fly
{
    SKAction* fly = [self actionForKey:@"fly"];
    if(fly == nil)
    {
        NSMutableString* name;
        SKTexture* birdTexture;
        NSMutableArray* textures = [NSMutableArray arrayWithCapacity:BIRD_COUNT];
        for (int i = 1; i <= BIRD_COUNT; i++) {
            name = [NSMutableString stringWithFormat:@"bird_%d", i];
            birdTexture = [[SKTextureAtlas getTexureCache] textureNamed:name];
            [textures addObject:birdTexture];
        }
        fly = [SKAction repeatActionForever:([SKAction animateWithTextures:textures timePerFrame:0.2])];
        [self runAction:fly withKey:@"fly"];
    }
    else{
        
        [self runAction:fly withKey:@"fly"];
    }
}
-(void)startFly
{
    if(upSound == nil)
    {
        upSound = [SKAction playSoundFileNamed:@"jump.wav" waitForCompletion:NO];
    }
    if(overSound == nil)
    {
        overSound = [SKAction sequence:@[
                                         ([SKAction runBlock:^{
                                                [self removeActionForKey:@"fly"];
                                        }]),
                                         ([SKAction playSoundFileNamed:@"hurt.wav" waitForCompletion:YES])
        ]];
    }
    [self removeActionForKey:@"upAndDown"];
    if(self.physicsBody == nil)
    {
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.categoryBitMask = BIRD_MASK;
        self.physicsBody.density = 0.1f;
        self.physicsBody.restitution = 0.1;
    }
}
-(void) flyUp
{
    [self runAction:upSound];
    [self.physicsBody setVelocity:CGVectorMake(0, 0)];
    [self.physicsBody applyImpulse:CGVectorMake(0, 1.3)];
    
}

-(void)over
{
    [self runAction:overSound];
    [self.physicsBody applyForce:CGVectorMake(0, 0)];
    //    [self removeAllActions];
}

-(void)update:(NSTimeInterval)currentTime
{
    self.zRotation = M_PI * self.physicsBody.velocity.dy * 0.0005;
}
@end
