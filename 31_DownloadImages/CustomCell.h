//
//  ImagesCollectionViewController.m
//  31_DownloadImages
//
//  Created by oreko on 28.04.16.
//  Copyright © 2016 Orest Kashchiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

@class CustomCell;

@protocol CustomCellDelegate <NSObject>

- (void)customCell:(CustomCell *)customCell buttonTapped:(UIButton *)button;

@end

@interface CustomCell : UICollectionViewCell

@property (strong, nonatomic) CellModel *cellModel;
@property (weak, nonatomic) id<CustomCellDelegate> delegate;

@end
