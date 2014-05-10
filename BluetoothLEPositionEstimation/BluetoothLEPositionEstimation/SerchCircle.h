//
//  SerchCircle.h
//  BluetoothLESample
//


#import <SpriteKit/SpriteKit.h>

@interface SerchCircle : SKSpriteNode{
    
}
@property (assign) float ScaleSpeed; // 追加
- (void)serch:(CFTimeInterval)timeSinceLastUpdate; // 追加



@end
