local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)
local reloadMessagesForConversations = require(script.Parent.reloadMessagesForConversations)

local function reloadAllMessages()
	return function(object)
		local conversations = object:getState().ChatAppReducer.Conversations
		return object:dispatch(reloadMessagesForConversations(Cryo.Dictionary.keys(conversations)))
	end
end

return reloadAllMessages
