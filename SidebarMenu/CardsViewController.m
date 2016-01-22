//
//  CardsViewController.m
//  SidebarMenu
//
//  Created by Michael Young on 1/21/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

#import "CardsViewController.h"
#import "Cards.h"

@interface CardsViewController () {
    NSArray *photoArray;
    NSArray *titleArray;
    NSArray *nameArray;
    NSArray *descriptionArray;
    NSArray *cardSizeArray;
}

@end

@implementation CardsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadExampleData];
    
    //Refeshing Enabled Through code;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1]; //%%% This is so if you overscroll, the color is still gray
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [refreshControl endRefreshing];
}

-(void)loadExampleData
{
    /*
     this is just example data and you shouldn't be using your table like this because it's static.
     For example, if you want to have a news feed, you should be using an NSMutableArray and pulling
     the information from the internet somehow.  If you'd like some help figuring out the logistics,
     I'd be happy to help, contact me at cwrichardkim@gmail.com or twitter: @cwRichardKim
     */
    photoArray = [[NSArray alloc]initWithObjects:@"1",@"2",@"3", nil];
    titleArray = [[NSArray alloc]initWithObjects:@"First Card",@"Second Card",@"Third Card(Bigger)", nil];
    nameArray = [[NSArray alloc]initWithObjects:@"Things are gonna get",@"Easieerrrrr",@"ooooooh chiiiiild", nil];
    descriptionArray = [[NSArray alloc]initWithObjects:@"Dance off",@"Things are gonna get brighter",@"oooh oooh baeebeeee", nil];
    cardSizeArray = [[NSArray alloc]initWithObjects:@200,@200,@200, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //%%% this is asking for the number in the cardSizeArray.  If you're seriously
    // thinking about making your cards dynamic, they should depend on something more reliable
    // for example, facebook's post sizes depend on whether it's a status update or photo, etc
    // so there should be a switch statement in here that returns different heights depending on
    // what kind of post it is.  Also, don't forget to change the height of the
    // cardView if you use dynamic cards
    return [((NSNumber*)[cardSizeArray objectAtIndex:indexPath.row])intValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning you're going to want to change this
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning you're going to want to change this
    return 3;
}

//creates cell with a row number (0,1,2, etc), sets the name and description as strings from event object
//from _events
//called after hitting "activate" button, numberOfSectionsInTableView times per event
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cards *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cards"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[Cards alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cards"];
    }
    
    cell.profileImage.image = [UIImage imageNamed:[photoArray objectAtIndex:indexPath.row]];
    cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [nameArray objectAtIndex:indexPath.row];
    cell.descriptionLabel.text = [descriptionArray objectAtIndex:indexPath.row];
    
    //%%% I made the cards pseudo dynamic, so I'm asking the cards to change their frames depending on the height of the cell
    cell.cardView.frame = CGRectMake(10, 5, 300, [((NSNumber*)[cardSizeArray objectAtIndex:indexPath.row])intValue]-10);
    
    return cell;
}

@end