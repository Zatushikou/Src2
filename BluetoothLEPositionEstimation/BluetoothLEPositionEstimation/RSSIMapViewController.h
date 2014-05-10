//
//  BLEMapViewController.h
//  BluetoothLESample
//


#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "PeripheralViewController.h"

@interface RSSIMapViewController : PeripheralViewController{
    NSTimer *_timer;
}
//@property PeripheralManager *peripheralManager;
@property (weak, nonatomic) IBOutlet UILabel *RSSI_label_red;
@property (weak, nonatomic) IBOutlet UILabel *RSSI_label_black;
@property (weak, nonatomic) IBOutlet UILabel *RSSI_label_white;
@end
