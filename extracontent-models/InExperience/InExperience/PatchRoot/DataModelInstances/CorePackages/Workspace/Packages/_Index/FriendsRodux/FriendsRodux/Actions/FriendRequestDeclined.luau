local parent = script:FindFirstAncestor("FriendsRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(ids)
	return { ids = ids }
end)
