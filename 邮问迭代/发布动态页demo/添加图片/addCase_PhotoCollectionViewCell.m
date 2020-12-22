//
//  addCase_PhotoCollectionViewCell.m
//  addCaseDemo
//
//  Created by 金波 on 2017/3/29.
//  Copyright © 2017年 Bob. All rights reserved.
//

#import "addCase_PhotoCollectionViewCell.h"

@implementation addCase_PhotoCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deleteButton.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    self.deleteButton.layer.masksToBounds = YES;
    self.deleteButton.layer.cornerRadius = 8.0;
}
-(IBAction)doDeleteAction:(id)sender
{
    NSLog(@"******%ld*****",_indexPath.item);
   if([self.delegate respondsToSelector:@selector(deleteCollectionCell:)])
      [self.delegate deleteCollectionCell:self.indexPath];
    
}

-(void)setImage:(UIImage *)image
{
    
    _photoImage.image=image;
}
@end
