local parent = script.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)
require(parent.roduxFriendsTypes)

return Rodux.makeActionCreator(script.Name, function(payload)
	return { payload = payload }
end)
