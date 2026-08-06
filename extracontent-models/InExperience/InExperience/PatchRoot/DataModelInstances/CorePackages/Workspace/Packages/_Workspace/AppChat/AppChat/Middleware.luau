local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local FFlagAppChatFriendsTabIxpEnabled = require(AppChat.Flags.FFlagAppChatFriendsTabIxpEnabled)
local FFlagExpChatEnableFriendsTab = require(AppChatParent.SharedFlags).FFlagExpChatEnableFriendsTab

return {
	ChatModerationStatusHydrationMiddleware = require(script.ChatModerationStatusHydrationMiddleware),
	SignalsConversationMiddleware = require(script.SignalsConversationMiddleware),
	SignalsFriendsChatSettingsMiddleware = if not FFlagAppChatFriendsTabIxpEnabled and not FFlagExpChatEnableFriendsTab then nil else require(script.SignalsFriendsChatSettingsMiddleware),
	SignalsMessageIngestionMiddleware = require(script.SignalsMessageIngestionMiddleware)
}
