//
//  SKTextureAtlas+TextureCache.m
//  HappyBird
//
//  Created by Minko on 14-5-13.
//  Copyright (c) 2014年 com.minko.bird. All rights reserved.
//

#import "SKTextureAtlas+TextureCache.h"

static SKTextureAtlas* cache;

@implementation SKTextureAtlas (TextureCache)

+(void)addTextureWithName:(NSString *)name
{
    cache = [SKTextureAtlas atlasNamed:name];
}

+(SKTextureAtlas *)getTexureCache
{
    return cache;
}
@end
