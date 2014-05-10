//
//  ViewController.h
//  BluetoothLESample
//


#import <UIKit/UIKit.h>
#import "PeripheralViewController.h"
#import "RSSIMapViewController.h"

@interface ViewController : PeripheralViewController {
    NSTimer *_timer;
    //PeripheralManager *peripheralManager;
}
//@property (nonatomic,retain) PeripheralManager *peripheralManager;

@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *connectButtonRed;
@property (weak, nonatomic) IBOutlet UIButton *connectButtonBlack;
@property (weak, nonatomic) IBOutlet UIButton *connectButtonWhite;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *alertButton;
@property (weak, nonatomic) IBOutlet UIButton *batteryButton;
@property (weak, nonatomic) IBOutlet UILabel *RSSI_label;

@property (weak, nonatomic) IBOutlet UILabel *label_black;
@property (weak, nonatomic) IBOutlet UIButton *alertButton_black;
@property (weak, nonatomic) IBOutlet UIButton *batteryButton_black;
@property (weak, nonatomic) IBOutlet UILabel *RSSI_label_black;

@property (weak, nonatomic) IBOutlet UILabel *label_white;
@property (weak, nonatomic) IBOutlet UIButton *alertButton_white;
@property (weak, nonatomic) IBOutlet UIButton *batteryButton_white;
@property (weak, nonatomic) IBOutlet UILabel *RSSI_label_white;

- (IBAction)connectButtonTouched:(id)sender;

- (IBAction)connectButtonRedTouched:(id)sender;
- (IBAction)connectButtonBlackTouched:(id)sender;
- (IBAction)connectButtonWhiteTouched:(id)sender;


- (IBAction)alertButtonTouched:(id)sender;
- (IBAction)batteryButtonTouched:(id)sender;

- (IBAction)alertButtonBlackTouched:(id)sender;
- (IBAction)batteryButtonBlackTouched:(id)sender;

- (IBAction)alertButtonWhiteTouched:(id)sender;
- (IBAction)batteryButtonWhiteTouched:(id)sender;


- (void)updateRSSI:(NSTimer*)timer;

@end
