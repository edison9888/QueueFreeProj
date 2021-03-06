//
//  GlobalSearchListViewController.m
//  QueueFree
//
//  Created by BuG.BS on 12-10-26.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "GlobalSearchListViewController.h"
#import "QFAppDelegate.h"


@interface GlobalSearchListViewController ()<GSTableViewDelegate,GSMapViewDelegate,QFAppDelegate>
@property (nonatomic) BOOL isList;
@property (nonatomic) BOOL hasList;
@property (nonatomic) BOOL hasArrayOfMap;
@property (nonatomic, strong) QFGlobalSearchBrain *searchBrain;
@end

@implementation GlobalSearchListViewController
@synthesize searchBrain;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.isList = YES;
    self.hasList = NO;
    self.hasArrayOfMap = NO;
    self.viewChangeButton.title = @"地图";
    
    self.globalSearchTVC = [[GSTableViewController alloc]init];
    self.globalSearchMVC = [GSMapViewController alloc];
    self.globalSearchMVCTemp = [[GSMapViewController alloc]init];
    
    self.globalSearchTVC.delegate = self;
    self.globalSearchMVC.delegate = self;
    
    ((QFAppDelegate *)[[UIApplication sharedApplication] delegate]).DataDelegate = self;
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(sendData:) withObject:@{@"signal":@"4", @"data":[@"4;" dataUsingEncoding:NSUTF8StringEncoding]}];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    ((QFAppDelegate *)[[UIApplication sharedApplication] delegate]).DataDelegate = self;
}

- (void)viewDidUnload {
    [self setKeyword:nil];
    [self setViewChangeButton:nil];
    [self setTheFormerView:nil];
    [super viewDidUnload];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.keyword isExclusiveTouch]){
        [self.keyword resignFirstResponder];
    }
}

- (IBAction)searchButtonPressed:(id)sender
{
    if (![self.keyword isExclusiveTouch]){
        [self.keyword resignFirstResponder];
        
        searchBrain = [[QFGlobalSearchBrain alloc] init];
        
        NSArray* resultList = [searchBrain theResultArrayForKeyWord:self.keyword.text];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *rest in resultList) {
            NSLog(@"%@",[rest valueForKey:@"名称"]);
            [tempArr addObject:rest];
        }
        self.globalSearchTVC.resultArray = tempArr;
        self.globalSearchMVC.resultArrayForMap = [NSArray arrayWithArray:self.globalSearchTVC.resultArray];
        [self.globalSearchTVC.gsTableView reloadData];
        [self.globalSearchMVC init];
        [self.theFormerView insertSubview:self.globalSearchTVC.view atIndex:0];
        self.hasArrayOfMap = YES;
        self.hasList = YES;
    }
}

- (IBAction)viewChangeButtonPressed:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    if(self.isList)
    {
        if(self.hasArrayOfMap)
        {
            [self.globalSearchMVCTemp.mapView removeFromSuperview];
            [self.theFormerView insertSubview:self.globalSearchMVC.mapView atIndex:1];
        }
        else
            [self.theFormerView insertSubview:self.globalSearchMVCTemp.mapView atIndex:1];
        self.isList = !self.isList;
    }
    else
    {
        if(self.hasList)
            [self.theFormerView exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
        else
            if(self.hasArrayOfMap)
                [self.globalSearchMVC.mapView removeFromSuperview];
            else
                [self.globalSearchMVCTemp.mapView removeFromSuperview];
        self.isList = !self.isList;
    }
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
    //self.isList = !self.isList;
    self.viewChangeButton.title = self.isList ? @"地图" : @"列表";
}

#pragma mark segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GlobalToRestaurant"]){
        NSString *name = sender;
        RestaurantViewController *newVC = segue.destinationViewController;
        [newVC initWithShop:name];
    }
}


#pragma mark delegate
- (void)performSegue:(NSString *)shopName
{
    [self performSegueWithIdentifier:@"GlobalToRestaurant" sender:shopName];
}

-(UIButton *)createTheButtonWithPinTitle:(NSString *)title
{
    NSArray *root = [[[UIApplication sharedApplication] delegate] performSelector:@selector(getDataArray)];
    for(countsOfCreateButton = 0 ; countsOfCreateButton < [root count] ; countsOfCreateButton++)
    {
        if(title == [[root objectAtIndex:countsOfCreateButton] valueForKey:@"名称"])
        {
            break;
        }
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button setTag:countsOfCreateButton];
    [button addTarget:self action:@selector(performTheSegue:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)performTheSegue:(id)sender
{
    NSArray *root = [[[UIApplication sharedApplication] delegate] performSelector:@selector(getDataArray)];
    int index = [(UIButton *)sender tag];
    NSString* name = [[root objectAtIndex:index] valueForKey:@"名称"];
    [self performSegueWithIdentifier:@"GlobalToRestaurant" sender:name];
    
}

- (void)reloadDataOK:(id)sender
{
    [self.globalSearchTVC.gsTableView reloadData];
}

@end
