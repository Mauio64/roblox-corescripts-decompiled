local parent = script:FindFirstAncestor("RoduxShareLinks").Parent
local Rodux = require(parent.Rodux)

local Invites = require(script.Invites)

return function(p)
	return Rodux.combineReducers({ Invites = Invites(p) })
end
