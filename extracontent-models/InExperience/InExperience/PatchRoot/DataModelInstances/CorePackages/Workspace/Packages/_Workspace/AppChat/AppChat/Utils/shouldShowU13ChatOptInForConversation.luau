local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Conversation = require(AppChat.Models.Conversation)
local FFlagAppChatEnableU13ChatOptIn = require(AppChatParent.SharedFlags).FFlagAppChatEnableU13ChatOptIn

return function(p1) -- line: 6
	-- upvalues: FFlagAppChatEnableU13ChatOptIn (copy), Conversation (copy)
	if not FFlagAppChatEnableU13ChatOptIn then
		return false
	end

	if not p1 then
		return false
	end

	return p1.userOptedIntoChatMessages == Conversation.UserOptedIntoChatMessagesStatus.NotOptedIn
end
