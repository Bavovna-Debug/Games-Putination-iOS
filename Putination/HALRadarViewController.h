//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    HALSchemaDay,
    HALSchemaNight
} HALSchema;

@interface HALRadarViewController : UIViewController
{
    HALSchema schema;
}

- (void)playerHitByMissle;

@end
