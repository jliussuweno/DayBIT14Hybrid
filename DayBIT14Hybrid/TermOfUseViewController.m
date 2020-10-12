//
//  ViewController.m
//  DayBIT14Hybrid
//
//  Created by Jlius Suweno on 08/10/20.
//

#import "TermOfUseViewController.h"
#import "DayBIT14Hybrid-Swift.h"

@interface TermOfUseViewController ()

@end

@implementation TermOfUseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCheckbox];
}

- (IBAction)agreeTermOfUse:(UIButton *)sender {
    self.isTermAgreed = !self.isTermAgreed;
    [sender setSelected:self.isTermAgreed];
}
- (IBAction)startPressed:(UIButton *)sender {
    if(_isTermAgreed){
        [self initSession];
    } else {
        [self showAlert];
    }
    
    
}

-(void)initCheckbox {
    self.isTermAgreed = false;
    //    self.checkBoxButton.backgroundColor = [UIColor clearColor];
    //    self.checkBoxButton.layer.cornerRadius = 10;
    //    [self.checkBoxButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    //    [self.checkBoxButton.layer setBorderWidth: 1];
}

-(void)showAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Attention"
                                                                   message:@"Please accept the term and condition first"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)initSession {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    RestWebService *service = [[RestWebService alloc] init];
    UrlRequestBuilder *builder = [[UrlRequestBuilder alloc] init];
    NSURLRequest *request = [builder buildUrlRequestInitSession];
    [service sendRequestWithUrlRequest:request input:nil completion:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *status  = result[@"status"];
            if([status isEqualToString:@"ok"]){
                NSString *status = result[@"SessionID"];
                [self acceptAgreeToTermOfUse:status];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Attention"
                                                                               message:@"Error to Init Session"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        });
    }];
}

-(void)acceptAgreeToTermOfUse:(NSString *)sessionID {
    UrlRequestBuilder *builder = [[UrlRequestBuilder alloc] init];
    [builder buildURlRequestAcceptTermOfUseWithSessionID:sessionID];
    RestWebService *service = [[RestWebService alloc] init];
    NSURLRequest *request = [builder buildUrlRequestInitSession];
    [service sendRequestWithUrlRequest:request input:nil completion:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *status  = result[@"status"];
            if([status isEqualToString:@"ok"]){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self performSegueWithIdentifier:@"SegueIdentifier" sender:self];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Attention"
                                                                               message:@"Error to Agree Term of Use"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        });
    }];
}

@end
