#import "GHRepositories.h"
#import "GHRepository.h"
#import "GHUser.h"
#import "iOctocat.h"
#import "NSDictionary+Extensions.h"


@implementation GHRepositories

- (void)setValues:(id)values {
	self.items = [NSMutableArray array];
	for (NSDictionary *dict in values) {
		NSString *owner = [dict safeStringForKeyPath:@"owner.login"];
		NSString *name = [dict safeStringForKey:@"name"];
		GHRepository *repo = [[GHRepository alloc] initWithOwner:owner andName:name];
		[repo setValues:dict];
		[self addObject:repo];
	}
	[self sortUsingSelector:@selector(compareByName:)];
}

- (void)sortByPushedAt {
	NSComparisonResult (^compareRepositories)(GHRepository *, GHRepository *);
	compareRepositories = ^(GHRepository *repo1, GHRepository *repo2) {
		if (!repo1.pushedAtDate) return NSOrderedDescending;
		if (!repo2.pushedAtDate) return NSOrderedAscending;
		return (NSInteger)[repo2.pushedAtDate compare:repo1.pushedAtDate];
	};
	[self sortUsingComparator:compareRepositories];
}

@end