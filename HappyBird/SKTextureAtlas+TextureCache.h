//
//  SKTextureAtlas+TextureCache.h
//  HappyBird
//  将当前加载的纹理保存起来
//  Created by Minko on 14-5-13.
//  Copyright (c) 2014年 com.minko.bird. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKTextureAtlas (TextureCache)
+(void)addTextureWithName:(NSString*) name;
+(SKTextureAtlas*)getTexureCache;
@end
