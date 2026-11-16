local parent = script:FindFirstAncestor("ExpChatShared").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(p)
	return { userId = tostring(p) }
end)
