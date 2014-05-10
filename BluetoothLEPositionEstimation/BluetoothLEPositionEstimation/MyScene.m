//
//  MyScene.m
//  BluetoothLESample
//


#import "MyScene.h"

@implementation MyScene
//@synthesize rssi1,rssi2,rssi3;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        //self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"rader_background"];
        sn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        //sn.name = @"BACKGROUND";
        [self addChild:sn];
        
        SKSpriteNode *STANDS = [SKSpriteNode spriteNodeWithImageNamed:@"stand_mark"];
        STANDS.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        //sn.name = @"BACKGROUND";
        STANDS.xScale = 5.0f / 10.0f;
        STANDS.yScale = 5.0f / 10.0f;
        [self addChild:STANDS];
        
        serch_circle = [SerchCircle spriteNodeWithImageNamed:@"circle_black"];
        serch_circle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        serch_circle.ScaleSpeed = 1;
        
        [self addChild:serch_circle];
        
        owner = [Owner spriteNodeWithImageNamed:@"owner_mark"];
        owner.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        owner.xScale = 3.0f/10.0f;
        owner.yScale = 3.0f/10.0f;
        owner.base_x = CGRectGetMidX(self.frame);
        owner.base_y = CGRectGetMidY(self.frame);

        
        [self addChild:owner];
        NSLog(@"init mysccene");
        
    }
    _rssi1 = _rssi2= _rssi3= 0;
    return self;
}
-(void)update:(CFTimeInterval)currentTime {
    // 前回のフレームの更新時刻を記憶しておく
    dispatch_once(&lastUpdatedAtInitToken, ^{
        lastUpdatedAt = currentTime;
    });
    
    // 前回フレーム更新からの経過時刻を計算する
    CFTimeInterval timeSinceLastUpdate = currentTime - lastUpdatedAt;
    lastUpdatedAt = currentTime;
    [serch_circle serch:timeSinceLastUpdate];
    //[owner move:timeSinceLastUpdate RSSI1:_rssi1 RSSI2:_rssi2 RSSI3:_rssi3 ];
    [owner movef:timeSinceLastUpdate RSSI1:_rssi1f RSSI2:_rssi2f RSSI3:_rssi3f ];
    //NSLog(@"myscene : %d",rssi1);
}
@end
