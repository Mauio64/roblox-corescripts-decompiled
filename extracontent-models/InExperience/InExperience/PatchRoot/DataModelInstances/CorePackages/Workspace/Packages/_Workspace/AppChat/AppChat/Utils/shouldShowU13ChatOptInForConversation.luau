local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local Conversation = require(AppChat.Models.Conversation)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatEnableU13ChatOptIn = SharedFlags.FFlagAppChatEnableU13ChatOptIn

return function(p): boolean
	if not FFlagAppChatEnableU13ChatOptIn then
		return false
	end

	if p then
		return p.userOptedIntoChatMessages == Conversation.UserOptedIntoChatMessagesStatus.NotOptedIn
	end

	return false
end
