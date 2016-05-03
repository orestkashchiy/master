//
//  ImagesCollectionViewController.m
//  31_DownloadImages
//
//  Created by oreko on 28.04.16.
//  Copyright © 2016 Orest Kashchiy. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation CustomCell

-  (void)prepareForReuse {
    self.imageView.image = nil;
    self.button.selected = NO;
}

#pragma mark - Setters

- (void)setCellModel:(CellModel *)cellModel {
    _cellModel = cellModel;
    self.imageView.image = self.cellModel.image;
    self.progressView.progress = self.cellModel.progress;
    self.button.selected = self.cellModel.buttonSelected;
}

#pragma mark - IBActions

- (IBAction)buttonTapped:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate customCell:self buttonTapped:sender];
    }
}

@end
