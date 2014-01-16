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

 Selects the smallest (or largest if you want to sort from big to small) elements of the array and
 placing it at the head of the array. Then the process is repeated for the remainder of the array
 the next largest element is selected and put in the next slot and so on down the line
 
 Because the selection sort looks at progressively smaller parts of the array each time
 (as it knows to ignore the front of the array because it is already in order) a selection
 sort is slightly faster than a bubble sort, and can be better than a modified bubble sort
 
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
