//
//  MKMyScene.m
//  HappyBird
//
//  Created by Minko on 14-5-12.
//  Copyright (c) 2014年 com.minko.bird. All rights reserved.
//

#import "MKMyScene.h"
#import "BirdSprites.h"
#import "SKTextureAtlas+TextureCache.h"
#import "MKBird.h"
#import "MKScrollNode.h"
#import "SKNode+Position.h"
#import "MKGameController.h"
#import "MKMask.h"
#import "SpriteKit+QuickLook.h"

const int PIPE_MIN_HEGHT = 60;
const int PIPE_GAP_WIDTH = 130;
const int TOP_BOTTOM_GAP = 100;
@implementation MKMyScene
{
    SKTextureAtlas* atlas;
    MKScrollNode* background;
    MKScrollNode* floor;
    BOOL start;
    BOOL isOver;
    id<GameDelegate> delegate;
    NSMutableArray* pipes;
    NSUInteger pipesCount;
    CGSize pipeSize;
}
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /*使用一个cache保存当前纹理*/
        [SKTextureAtlas addTextureWithName:BIRDS_ATLAS_NAME];
        atlas = [SKTextureAtlas getTexureCache];
        start = NO;
        isOver = NO;
        pipes = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view
{
    /*添加背景*/
    [self createBackground];
    [self createFloor];
    [self createReayView];
    [self createBird];
    SKTexture* pipeTexture = [atlas textureNamed:@"pipe_top"];
    pipeSize = pipeTexture.size;
    pipesCount = ceil((self.frame.size.width + PIPE_GAP_WIDTH)/(pipeSize.width + PIPE_GAP_WIDTH) * 1.0f);
    self.physicsWorld.contactDelegate = self;
    delegate = [[MKGameController alloc] initWithNode:self];
}

-(void)update:(NSTimeInterval)currentTime
{
    if(isOver) return;
    [background updata:currentTime];
    [floor updata:currentTime];
    [self.bird update:currentTime];
    [self pipeUpdate];
}
/**
 *  添加背景
 */
-(void) createBackground
{
    background = [MKScrollNode scrollWithName:@"back"];
    background.scrollSpeed = -3.0f;
    [self addChild:background];
}

-(void) createReayView
{
    SKSpriteNode* tip = [SKSpriteNode spriteNodeWithTexture:([atlas textureNamed:@"taptap"])];
    tip.name = @"tip";
    CGPoint p = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [tip setPosition:p];
    [self addChild:tip];
    SKSpriteNode* ready = [SKSpriteNode spriteNodeWithTexture:([atlas textureNamed:@"get_ready"])];
    ready.name = @"ready";
    ready.position = CGPointMake(CGRectGetMidX(self.frame), tip.position.y + tip.size.height/2 + ready.size.height/2 + 10);
    [self addChild:ready];
}

-(void) cleanReadyView
{
    [[self childNodeWithName:@"tip"] removeFromParent];
    [[self childNodeWithName:@"ready"] removeFromParent];
}
/**
 *  创建一只小鸟并且飞翔
 *
 *  @return 一只小鸟
 */
-(void) createBird
{
    if(self.bird == nil)
    {
        self.bird = [MKBird bird];
        [self addChild:self.bird];
    }
    self.bird.physicsBody = nil;
    [self.bird setPosition:(CGPointMake(100, 300))];
    [self.bird changeState:BIRD_FLY];
    SKAction* down = [SKAction moveByX:([self getPositionX]) y:([self getPositionY] + 20) duration:0.3];
    SKAction* up = [down reversedAction];
    SKAction* upAndDown = [SKAction repeatActionForever:([SKAction sequence:@[down, up]])];
    [self.bird runAction:upAndDown withKey:@"upAndDown"];
    [self.bird changeState:BIRD_FLY];
}

-(void) createFloor
{
    floor = [MKScrollNode scrollWithName:@"floor"];
    floor.zPosition = 100;
    [self addChild:floor];
    floor.scrollSpeed = -2.0f;

    CGRect frame = CGRectMake(0, floor.size.height, self.size.width, 1);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:frame];
    self.physicsBody.categoryBitMask = FLOOR_MASK;
    self.physicsBody.contactTestBitMask = BIRD_MASK;
    self.physicsBody.restitution = 0;
    self.physicsBody.dynamic = NO;
}

-(void)createPipe
{
    SKSpriteNode* pipeBottom =[SKSpriteNode spriteNodeWithTexture:([atlas textureNamed:@"pipe_bottom"])];
    pipeBottom.anchorPoint = CGPointMake(0, 0);
    pipeBottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:(CGRectMake(0, 0, pipeSize.width, pipeSize.height))];
    pipeBottom.physicsBody.dynamic = NO;
    pipeBottom.physicsBody.categoryBitMask = PIPE_MASK;
    pipeBottom.physicsBody.contactTestBitMask = BIRD_MASK;
   
    SKSpriteNode* pipeTop =[SKSpriteNode spriteNodeWithTexture:([atlas textureNamed:@"pipe_top"])];
    pipeTop.anchorPoint = CGPointMake(0, 0);
    pipeTop.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:(CGRectMake(0, 0, pipeSize.width, pipeSize.height))];
    pipeTop.physicsBody.dynamic = NO;
    pipeTop.physicsBody.categoryBitMask = PIPE_MASK;
    pipeTop.physicsBody.contactTestBitMask = BIRD_MASK;
    
    [self resetTopPipe:pipeTop andBottom:pipeBottom];
    [self addChild:pipeTop];
    [self addChild:pipeBottom];
    [pipes addObject:@{@"top":pipeTop, @"bottom":pipeBottom}];
}

-(void)pipeUpdate
{
    if(start == NO) return;
    SKSpriteNode* last = (SKSpriteNode*)([((NSDictionary*)pipes.lastObject) valueForKey:@"top"]);
    float creatyByX = (self.frame.size.width - pipeSize.width - PIPE_GAP_WIDTH);
    if(pipes.count == 0 || (pipes.count < pipesCount && last.position.x <= creatyByX))
    {
        [self createPipe];
    }
    SKSpriteNode* bottom;
    SKSpriteNode* top;
    float lastX = last.position.x;
    for (NSDictionary* child in pipes) {
        top = [child valueForKey:@"top"];
        lastX = MAX(top.position.x, lastX);
    }
    for (NSDictionary* child in pipes) {
        top = [child valueForKey:@"top"];
        bottom = [child valueForKey:@"bottom"];
        top.position = CGPointMake((top.position.x + floor.scrollSpeed), (top.position.y));
        bottom.position = CGPointMake(top.position.x, bottom.position.y);
        if(top.position.x <= -top.size.width && lastX <= creatyByX)
        {
            [self resetTopPipe:top andBottom:bottom];
        }
    }
}

-(void)resetTopPipe:(SKSpriteNode*) top andBottom:(SKSpriteNode*) bottom
{
    bottom.position = CGPointMake(self.size.width, ([self randomY] - pipeSize.height));
    top.position = CGPointMake(bottom.position.x, bottom.position.y + TOP_BOTTOM_GAP + pipeSize.height);
}

-(float)randomY
{
    float minY = PIPE_MIN_HEGHT + floor.size.height;
    float maxY = self.size.height - PIPE_MIN_HEGHT - PIPE_GAP_WIDTH;
    float random =  ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(maxY-minY)+minY;
    return ceilf(random);
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if([delegate respondsToSelector:@selector(gameOver)] && isOver == NO)
    {
        [delegate performSelector:@selector(gameOver)];
        isOver = YES;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isOver)
    {
        [self restart];
        return;
    };
    if(!start)
    {
        start = true;
        [self cleanReadyView];
        [delegate performSelector:@selector(gameStart)];
    }
    [delegate performSelector:@selector(gamePlay)];
}

-(void)restart
{
    [self createReayView];
    for (NSDictionary* child in pipes) {
        for (NSString* key in child)
        {
            [((SKSpriteNode*)([child valueForKey:key])) removeFromParent];
        }
    }
    [pipes removeAllObjects];
    [self createBird];
    start = NO;
    isOver = NO;
}
@end
