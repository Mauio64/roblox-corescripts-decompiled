local parent = script:FindFirstAncestor("AppChat").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(conversationId, title, isDefaultTitle, lastUpdated)
	return {
		conversationId = conversationId,
		title = title,
		isDefaultTitle = isDefaultTitle,
		lastUpdated = lastUpdated
	}
end)
