local parent = script:FindFirstAncestor("AppChat").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(conversationId, participants, title, lastUpdated)
	return {
		conversationId = conversationId,
		participants = participants,
		title = title,
		lastUpdated = lastUpdated
	}
end)
