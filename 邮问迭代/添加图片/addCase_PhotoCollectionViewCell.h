//
//  addCase_PhotoCollectionViewCell.h
//  addCaseDemo
//
//  Created by 金波 on 2017/3/29.
//  Copyright © 2017年 Bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addCase_PhotoCollectionViewCelldelegate <NSObject>

-(void)deleteCollectionCell:(NSIndexPath*)indexPath;

@end

@interface addCase_PhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property(nonatomic,retain)UIImage *image;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property(nonatomic,weak)id<addCase_PhotoCollectionViewCelldelegate>delegate;
@property(nonatomic,retain)NSIndexPath *indexPath;
@end
