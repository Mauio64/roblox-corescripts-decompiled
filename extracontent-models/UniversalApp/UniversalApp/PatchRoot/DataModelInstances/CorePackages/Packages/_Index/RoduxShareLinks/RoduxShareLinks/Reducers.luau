local Parent = script:FindFirstAncestor("RoduxShareLinks").Parent
local Rodux = require(Parent.Rodux)
local Invites = require(script.Invites)

return function(p1) -- line: 7
	-- upvalues: Rodux (copy), Invites (copy)
	return Rodux.combineReducers({
		Invites = Invites(p1)
	})
end
