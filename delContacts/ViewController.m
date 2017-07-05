//
//  ViewController.m
//  delContacts
//
//  Created by 辛亚鹏 on 2017/7/5.
//  Copyright © 2017年 yapeng. All rights reserved.
//

#import "ViewController.h"

#import <Contacts/Contacts.h>
#import "MBProgressHUD+Simple.h"

#define YPWeakObj(objc) autoreleasepool{} __weak typeof(objc) objc##Weak = objc;
#define YPStrongObj(objc) autoreleasepool{} __strong typeof(objc) objc = objc##Weak;

@interface ViewController ()
@property (assign, nonatomic) NSInteger num;
@property (nonatomic) UILabel *label;

@end

@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestAuthorizationForAddressBook];
    self.title = @"删除所有联系人";
    [self setupUI];
}

- (void)requestAuthorizationForAddressBook {
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [MBProgressHUD showMessageThenHide:@"授权 - 成功" toView:self.view];
            } else {
                [MBProgressHUD showMessageThenHide:@"授权 - 失败" toView:self.view];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupUI
{
    #define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
    #define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(70, 200, SCREEN_WIDTH - 140, 50)];
    [self.view addSubview:btn];
    [btn setTitle:@"删手机中所有联系人" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 300, SCREEN_WIDTH - 140, 40)];
    self.label = label;
    label.layer.borderWidth = 1.f;
    label.layer.borderColor = [UIColor darkGrayColor].CGColor;
    label.layer.cornerRadius = 3.f;
    label.layer.masksToBounds = YES;
    [self.view addSubview:label];
    [self labelWithNum:0];
    
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 70, SCREEN_WIDTH - 40, 40)];
    copyrightLabel.text = @"  Copyright © 2017年 辛亚鹏. All rights reserved. ";
    copyrightLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:copyrightLabel];
}

- (void)labelWithNum:(int)num
{
    NSString *str = [NSString stringWithFormat:@"删除 %i 个联系人", num];
    self.label.text = str;
}

- (void)click
{
    NSString *str = @"使用之前请先备份通讯录中有用的号码";
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择" message:str preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertVC animated:YES completion:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self contactNOUI];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
}


- (void)contactNOUI
{
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusAuthorized) {
    }
    else {
        NSString *titleStr = @"未取得授权";
        NSString *messageStr = @"需要前往设置 -> 隐私 -> 通讯录 设置授权";
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:nil];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            abort();
        }];
        [alertVC addAction:action];
    }
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    [MBProgressHUD showMessageThenHide:@"开始删除" toView:self.view];
    
    __weak __typeof__(self) weakSelf = self;
    __block int a = 0;
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        CNMutableContact *contactM = [contact mutableCopy];
        CNSaveRequest * saveRequest = [[CNSaveRequest alloc]init];
        [saveRequest deleteContact:contactM];
        a++;
        NSError *error;
        if ([contactStore executeSaveRequest:saveRequest error:&error]) {
            if (error) {
                NSString *str = [NSString stringWithFormat:@"发生错误, 请重试, error: %@", [error description]];
                [MBProgressHUD showMessageThenHide:str toView:weakSelf.view];
                *stop = YES;
            }
            else {
                [weakSelf labelWithNum:a];
            }
        }
        else {
            NSString *str = @"请求失败, 请重试";
            [MBProgressHUD showMessageThenHide:str toView:weakSelf.view];
            *stop = YES;
        }
        
    }];

}



@end
