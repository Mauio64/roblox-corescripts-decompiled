local parent = script:FindFirstAncestor("ExpChatShared").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(isGlobalTabActive: boolean?)
	return { isGlobalTabActive = isGlobalTabActive }
end)
