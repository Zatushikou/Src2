//
//  PeripheralViewController.h
//  BluetoothLESample
//


#import <UIKit/UIKit.h>
#import "PeripheralManager.h"

@interface PeripheralViewController : UIViewController<PeripheralManagerDelegate>
@property PeripheralManager *peripheralManager;
@end
