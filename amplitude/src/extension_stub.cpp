#if !defined(DM_PLATFORM_IOS)

#include "extension.h"

int EXTENSION_INIT(lua_State *L) {
	dmLogInfo("init");
	return 0;
}

int EXTENSION_TRACK_EVENT(lua_State *L) {
	dmLogInfo("track_event");
	return 0;
}

int EXTENSION_SET_USER_PROPERTY(lua_State *L) {
	dmLogInfo("set_user_property");
	return 0;
}

void EXTENSION_INITIALIZE(lua_State *L) {
}

void EXTENSION_UPDATE(lua_State *L) {
}

void EXTENSION_APP_ACTIVATE(lua_State *L) {
}

void EXTENSION_APP_DEACTIVATE(lua_State *L) {
}

void EXTENSION_FINALIZE(lua_State *L) {
}

#endif
