local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local FFlagAppChatFriendsTabIxpEnabled = require(AppChat.Flags.FFlagAppChatFriendsTabIxpEnabled)
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

local Middleware = {
	ChatModerationStatusHydrationMiddleware = require(script.ChatModerationStatusHydrationMiddleware),
	SignalsConversationMiddleware = require(script.SignalsConversationMiddleware),
	SignalsFriendsChatSettingsMiddleware = 0,
	SignalsMessageIngestionMiddleware = 0,
	SignalsUnreadMessageCountMiddleware = 0
}
local signalsFriendsChatSettingsMiddleware

if FFlagAppChatFriendsTabIxpEnabled or FFlagExpChatEnableFriendsTab then
	signalsFriendsChatSettingsMiddleware = require(script.SignalsFriendsChatSettingsMiddleware)
end

Middleware.SignalsFriendsChatSettingsMiddleware = signalsFriendsChatSettingsMiddleware

Middleware.SignalsMessageIngestionMiddleware = require(script.SignalsMessageIngestionMiddleware)
Middleware.SignalsUnreadMessageCountMiddleware = require(script.SignalsUnreadMessageCountMiddleware)
return Middleware
