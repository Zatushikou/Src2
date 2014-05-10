//
//  PeripheralViewController.m
//  BluetoothLESample
//


#import "PeripheralViewController.h"

@interface PeripheralViewController ()

@end

@implementation PeripheralViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    NSLog(@"init peripheralviewcontroller");
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.peripheralManager==nil){
        NSLog(@"peripheralmanager initialize");
        self.peripheralManager = [[PeripheralManager alloc] init];
        //self.peripheralManager.delegate = self;
    }
     self.peripheralManager.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
