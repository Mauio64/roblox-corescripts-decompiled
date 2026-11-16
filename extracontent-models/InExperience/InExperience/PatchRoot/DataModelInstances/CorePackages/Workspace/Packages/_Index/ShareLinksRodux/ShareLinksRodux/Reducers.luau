local parent = script.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

local Invites = require(parent.Reducers.Invites)

return function(p)
	return Rodux.combineReducers({ Invites = Invites(p) })
end
