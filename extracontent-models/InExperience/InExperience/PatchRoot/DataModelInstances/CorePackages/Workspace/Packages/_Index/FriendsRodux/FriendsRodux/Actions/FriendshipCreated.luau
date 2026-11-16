local parent = script.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)
require(parent.roduxFriendsTypes)

return Rodux.makeActionCreator(script.Name, function(userId: string, userId2: string)
	return {
		payload = { userId1 = userId, userId2 = userId2 }
	}
end)
