local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local fFlagAppChatEnableU13ChatOptIn = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatEnableU13ChatOptIn

return function(p2): boolean
	if not fFlagAppChatEnableU13ChatOptIn then
		return false
	end

	if p2 then
		return p2.userOptedIntoChatMessages == Conversation.UserOptedIntoChatMessagesStatus.NotOptedIn
	end

	return false
end
