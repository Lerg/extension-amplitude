#if defined(DM_PLATFORM_IOS)

#import <Amplitude/Amplitude.h>
#include "extension.h"

#import "ios/utils.h"

#define ExtensionInterface FUNCTION_NAME_EXPANDED(EXTENSION_NAME, ExtensionInterface)

// Using proper Objective-C object for main extension entity.
@interface ExtensionInterface : NSObject
@end

@implementation ExtensionInterface {
	bool is_initialized;
}

static ExtensionInterface *extension_instance;
int EXTENSION_INIT(lua_State *L) {return [extension_instance init_:L];}
int EXTENSION_TRACK_EVENT(lua_State *L) {return [extension_instance track_event:L];}
int EXTENSION_SET_USER_PROPERTY(lua_State *L) {return [extension_instance set_user_property:L];}

-(id)init:(lua_State*)L {
	self = [super init];

	is_initialized = false;

	return self;
}

-(bool)check_is_initialized {
	if (is_initialized) {
		return true;
	} else {
		dmLogInfo("The extension is not initialized.");
		return false;
	}
}

# pragma mark - Lua functions -

// amplitude.init(params)
-(int)init_:(lua_State*)L {
	[Utils check_arg_count:L count:1];
	if (is_initialized) {
		dmLogInfo("The extension is already initialized.");
		return 0;
	}

	Scheme *scheme = [[Scheme alloc] init];
	[scheme string:@"api_key"];

	Table *params = [[Table alloc] init:L index:1];
	[params parse:scheme];

	NSString *api_key = [params get_string_not_null:@"api_key"];

	[[Amplitude instance] initializeApiKey:api_key];

	is_initialized = true;

	return 0;
}

// amplitude.track_event(params)
-(int)track_event:(lua_State*)L {
	[Utils check_arg_count:L count:1];
	if (![self check_is_initialized]) {
		return 0;
	}

	Scheme *scheme = [[Scheme alloc] init];
	[scheme string:@"name"];
	[scheme table:@"event_properties"];
	[scheme string:@"event_properties.#"];

	Table *params = [[Table alloc] init:L index:1];
	[params parse:scheme];

	NSString *name = [params get_string_not_null:@"name"];
	NSDictionary *event_properties = [params get_table:@"event_properties"];

	if (event_properties) {
		[[Amplitude instance] logEvent:name withEventProperties:event_properties];
	} else {
		[[Amplitude instance] logEvent:name];
	}

	return 0;
}

// amplitude.set_user_property(params)
-(int)set_user_property:(lua_State*)L {
	[Utils check_arg_count:L count:1];
	if (![self check_is_initialized]) {
		return 0;
	}

	Scheme *scheme = [[Scheme alloc] init];
	[scheme string:@"name"];
	[scheme string:@"string"];
	[scheme number:@"number"];

	Table *params = [[Table alloc] init:L index:1];
	[params parse:scheme];

	NSString *name = [params get_string_not_null:@"name"];
	NSString *string = [params get_string:@"string"];
	NSNumber *number = [params get_double:@"number"];

	AMPIdentify *identify = NULL;
	if (string) {
		identify = [[AMPIdentify identify] set:name value:string];
	} else if (number) {
		identify = [[AMPIdentify identify] set:name value:number];
	}

	if (identify != NULL) {
		[[Amplitude instance] identify:identify];
	}

	return 0;
}

@end

#pragma mark - Defold lifecycle -

void EXTENSION_INITIALIZE(lua_State *L) {
	extension_instance = [[ExtensionInterface alloc] init:L];
}

void EXTENSION_UPDATE(lua_State *L) {
	[Utils execute_tasks:L];
}

void EXTENSION_APP_ACTIVATE(lua_State *L) {
}

void EXTENSION_APP_DEACTIVATE(lua_State *L) {
}

void EXTENSION_FINALIZE(lua_State *L) {
    extension_instance = nil;
}

#endif
