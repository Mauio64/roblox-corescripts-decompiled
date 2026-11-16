local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(bubbleChatMessageTable)
	return { bubbleChatMessageTable = bubbleChatMessageTable }
end)
