local Parent = script:FindFirstAncestor("AppChat").Parent
local FFlagExpChatEnableFriendsTab = require(Parent.SharedFlags).FFlagExpChatEnableFriendsTab

return {
	ChatModerationStatusHydrationMiddleware = require(script.ChatModerationStatusHydrationMiddleware),
	SignalsConversationMiddleware = require(script.SignalsConversationMiddleware),
	SignalsFriendsChatSettingsMiddleware = if not FFlagExpChatEnableFriendsTab then nil else require(script.SignalsFriendsChatSettingsMiddleware),
	SignalsMessageIngestionMiddleware = require(script.SignalsMessageIngestionMiddleware)
}
