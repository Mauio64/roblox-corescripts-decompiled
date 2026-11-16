local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(messageId: string, newText: string)
	return { messageId = messageId, newText = newText }
end)
