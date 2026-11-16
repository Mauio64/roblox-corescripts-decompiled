local FFlagAppChatFriendsTabIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFriendsTabIxpEnabled")
local fFlagExpChatEnableFriendsTab = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagExpChatEnableFriendsTab

local v5 = {
	ChatModerationStatusHydrationMiddleware = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Middleware/ChatModerationStatusHydrationMiddleware"),
	SignalsConversationMiddleware = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Middleware/SignalsConversationMiddleware"),
	SignalsFriendsChatSettingsMiddleware = 0,
	SignalsMessageIngestionMiddleware = 0,
	SignalsUnreadMessageCountMiddleware = 0
}

local v6 = if FFlagAppChatFriendsTabIxpEnabled or fFlagExpChatEnableFriendsTab then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Middleware/SignalsFriendsChatSettingsMiddleware") else nil
v5.SignalsFriendsChatSettingsMiddleware = v6

v5.SignalsMessageIngestionMiddleware = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Middleware/SignalsMessageIngestionMiddleware")
v5.SignalsUnreadMessageCountMiddleware = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Middleware/SignalsUnreadMessageCountMiddleware")
return v5
