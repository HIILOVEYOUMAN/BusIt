//
//  CardsHeader.h
//  SidebarMenu
//
//  Created by Michael Young on 1/20/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cards : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end