local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local reloadMessagesForConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/reloadMessagesForConversations")

local function reloadAllMessages()
	return function(object)
		local conversations = object:getState().ChatAppReducer.Conversations
		return object:dispatch(reloadMessagesForConversations(Cryo.Dictionary.keys(conversations)))
	end
end

return reloadAllMessages
