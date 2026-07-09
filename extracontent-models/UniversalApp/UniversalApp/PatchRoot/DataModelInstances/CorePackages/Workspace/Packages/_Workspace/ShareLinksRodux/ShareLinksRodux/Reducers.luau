local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Rodux = require(scriptParentParent.Rodux)
local Invites = require(scriptParent.Reducers.Invites)

return function(p1) -- line: 8
	-- upvalues: Rodux (copy), Invites (copy)
	return Rodux.combineReducers({
		Invites = Invites(p1)
	})
end
