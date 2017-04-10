//
//  BulletinPost.h
//  DA Mobile
//
//  Created by Yongyang Nie on 4/6/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import <Realm/Realm.h>

@interface BulletinPost : RLMObject

@property NSString *title;
@property NSString *content;
@property NSData *image;
@property NSDate *date;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<BulletinPost>
RLM_ARRAY_TYPE(BulletinPost)
