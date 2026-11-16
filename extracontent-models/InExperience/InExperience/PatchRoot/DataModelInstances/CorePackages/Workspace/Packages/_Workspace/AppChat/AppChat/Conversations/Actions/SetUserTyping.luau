local parent = script:FindFirstAncestor("AppChat").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(conversationId, userId, p)
	return { conversationId = conversationId, userId = userId, value = p }
end)
