//
//  ViewController.m
//  解剖---KVO
//
//  Created by 小萌 on 2017/5/26.
//  Copyright © 2017年 小萌. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+KVO.h"
@interface ViewController ()
@property (nonatomic, copy) Person *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     _person = [[Person alloc] init];
    _person.name = [NSString stringWithFormat:@"%d",2];

//    [_person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [_person xy_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"keypaht= %@  %@",keyPath,change);
}
- (IBAction)clickBtn:(UIButton *)sender
{
    static NSInteger i = 1;
    i++;
    _person.name = [NSString stringWithFormat:@"%d",i];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
