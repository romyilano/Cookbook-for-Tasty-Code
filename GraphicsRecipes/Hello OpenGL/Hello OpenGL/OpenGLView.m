//
//  OpenGLView.m
//  Hello OpenGL
//
//  Created by Romy Ilano on 1/28/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import "OpenGLView.h"

@implementation OpenGLView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(Class)layerClass
{
    // set up a view to display OpenGL content you need to set its
    //  default layer to a special kind of layer called a CAEAGLLayer
    return [CAEAGLLayer class];
}

-(void)setupLayer {
    
    _eaglLayer = (CAEAGLLayer *) self.layer;
    _eaglLayer.opaque = YES;
}

// to do anything with OpenGL you need to create an EAGLContext and
//  set the current context to the newly created context
-(void)setUpContext
{
    
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    
    // EAGLContext manages all info iOS needs to draw with OpenGL
    _context = [[EAGLContext alloc] initWithAPI:api];
    
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context])
    {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

-(void)setUpRenderBuffer
{
    glrender
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
