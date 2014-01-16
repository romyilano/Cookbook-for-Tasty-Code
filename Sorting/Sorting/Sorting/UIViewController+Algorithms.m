//
//  UIViewController+Algorithms.m
//  Sorting
//
//  Created by Romy Ilano on 1/16/14.
//  Copyright (c) 2014 Romy Ilano. All rights reserved.
//

#import "UIViewController+Algorithms.h"

@implementation UIViewController (Algorithms)

// this is for an array of ints
-(NSArray *)basicBubbleSort:(NSArray *)submittedArray
{
    NSMutableArray *workingArray = [[NSMutableArray alloc] initWithArray:submittedArray];
    
    for (int x = 0; x < workingArray.count; x++)
    {
        for (int y = 0; y < (workingArray.count - 1); x++)
        {
            // int only
            if (workingArray[y] > workingArray[y+1])
            {
                id temp = workingArray[y+1];
                workingArray[y+1] = workingArray[y];
                workingArray[y] = temp;
            }
        }
    }
    
    return [workingArray copy];
}

// simple selection sort
/*
 Slightly faster than a bubble sort
 Looks at progressively smaller parts of the array each time

 */
-(NSArray *)basicSelectionSort:(NSArray *)submittedArray
{
     NSMutableArray *workingArray = [[NSMutableArray alloc] initWithArray:submittedArray];
    
    for (int x = 0; x < workingArray.count; x++)
    {
        int index_of_min = x;
        
        for (int y = x; y < workingArray.count; y++)
        {
            if (workingArray[index_of_min] > workingArray[y])
            {
                index_of_min = y;
            }
        }
        
        id temp = workingArray[x];
        
        workingArray[x] = workingArray[index_of_min];
        
        workingArray[index_of_min] = temp;
        
    }
    
     return [workingArray copy];
}
@end
