local parent = script:FindFirstAncestor("FriendsRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(userId, userId2)
	return {
		payload = { userId1 = userId, userId2 = userId2 }
	}
end)
