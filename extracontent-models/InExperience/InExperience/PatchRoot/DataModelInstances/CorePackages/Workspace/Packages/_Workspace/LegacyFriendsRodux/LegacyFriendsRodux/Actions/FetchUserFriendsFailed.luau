local parent = script:FindFirstAncestor("LegacyFriendsRodux").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(userId, response)
	return { userId = userId, response = response }
end)
