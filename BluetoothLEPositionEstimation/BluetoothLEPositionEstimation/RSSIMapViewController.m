//
//  BLEMapViewController.m
//  BluetoothLESample
//


#import "RSSIMapViewController.h"
#import "MyScene.h"
#import "ViewController.h"

//a*b^x 近似曲線
#define a1 0.021
#define b1 1.06
#define a2 0.015
#define b2 1.07
#define a3 0.052
#define b3 1.05


@interface RSSIMapViewController ()

@end

@implementation RSSIMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    _timer = [NSTimer
              scheduledTimerWithTimeInterval:0.2
              target:self selector:@selector(updateRSSI:) userInfo:nil repeats:YES];
    NSLog(@"viewDidLoad");
    
}
- (BOOL)shouldAutorotate
{
    return NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
    [_timer invalidate];
    _timer = nil;
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
    // Dispose of any resources that can be recreated.
}
- (void)updateRSSI:(NSTimer*)timer{
    SKView * skView = (SKView *)self.view;
    MyScene * myscene = (MyScene *)skView.scene;
    
    if(self.peripheralManager.targetPeripheral_red.state ==  CBPeripheralStateConnected){
        [self.peripheralManager readRSSIofType:@"red"];
        //NSLog(@"%d",[peripheralManager.targetPeripheral.RSSI integerValue]);
        myscene.rssi1 =[self.peripheralManager.targetPeripheral_red.RSSI integerValue];
        myscene.rssi1f = 0.036*-[self.peripheralManager.targetPeripheral_red.RSSI floatValue]-1.25;
        myscene.rssi1f = a1*pow(b1,-[self.peripheralManager.targetPeripheral_red.RSSI floatValue]);
        self.RSSI_label_red.text = [NSString stringWithFormat:@"%f",myscene.rssi1f];
    }
    if(self.peripheralManager.targetPeripheral_black.state ==  CBPeripheralStateConnected){
        [self.peripheralManager readRSSIofType:@"black"];
        //NSLog(@"%d",[peripheralManager.targetPeripheral.RSSI integerValue]);
        myscene.rssi2 =[self.peripheralManager.targetPeripheral_black.RSSI integerValue];
        myscene.rssi2f = 0.046*-[self.peripheralManager.targetPeripheral_black.RSSI floatValue]-1.94;
        myscene.rssi2f = a2*pow(b2,-[self.peripheralManager.targetPeripheral_black.RSSI floatValue]);
        self.RSSI_label_black.text = [NSString stringWithFormat:@"%f",myscene.rssi2f];

        
    }
    if(self.peripheralManager.targetPeripheral_white.state ==  CBPeripheralStateConnected){
        [self.peripheralManager readRSSIofType:@"white"];
        //NSLog(@"%d",[peripheralManager.targetPeripheral.RSSI integerValue]);
        myscene.rssi3 =[self.peripheralManager.targetPeripheral_white.RSSI integerValue];
        myscene.rssi3f =0.049*-[self.peripheralManager.targetPeripheral_white.RSSI floatValue]-1.81;
        myscene.rssi3f = a3*pow(b3,-[self.peripheralManager.targetPeripheral_white.RSSI floatValue]);
        self.RSSI_label_white.text = [NSString stringWithFormat:@"%f",myscene.rssi3f];
    }

    
}
- (void)peripheralManagerDidDisconnectPeripheral:(PeripheralManager *)manager Type:(NSString *)type
{
    NSLog(@"peripheralManagerDidDisconnectPeripheral %@",type);
    if([type isEqualToString:@"red"]){
        NSLog(@"peripheralManagerDidDisconnectPeripheral %@",type);
        self.RSSI_label_red.text = @"-";
    }else if([type isEqualToString:@"black"]){
        self.RSSI_label_black.text = @"-";
    }else if([type isEqualToString:@"white"]){
        self.RSSI_label_white.text = @"-";
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Segueの特定
    if ( [[segue identifier] isEqualToString:@"toSetup"] ) {
        NSLog(@"prepareForSegue toSetup");
        ViewController *ViewController = [segue destinationViewController];
        //ここで遷移先ビューのクラスの変数receiveStringに値を渡している
        ViewController.peripheralManager = self.peripheralManager;

    }
    
}
@end
