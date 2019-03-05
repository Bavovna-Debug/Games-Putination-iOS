//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
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
