local parent = script:FindFirstAncestor("AppChat").Parent

local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(conversationId, messageId)
	return { conversationId = conversationId, messageId = messageId }
end)
