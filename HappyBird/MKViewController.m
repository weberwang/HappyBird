//
//  MKViewController.m
//  HappyBird
//
//  Created by Minko on 14-5-12.
//  Copyright (c) 2014年 com.minko.bird. All rights reserved.
//

#import "MKViewController.h"
#import "MKMyScene.h"

@implementation MKViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
//    skView.showsPhysics = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MKMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];

}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
