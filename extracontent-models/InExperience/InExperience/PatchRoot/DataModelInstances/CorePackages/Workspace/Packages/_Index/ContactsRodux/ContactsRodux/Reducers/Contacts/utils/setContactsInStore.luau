local parent = script.Parent.Parent.Parent.Parent
local types = parent.Types
require(types.ReducerTypes)
local parent2 = parent.Parent
require(types.ActionTypes)
local Dash = require(parent2.Dash)

return function(p)
	local userContactIds = p.responseBody.userContactIds
	local v = {}

	Dash.forEach(userContactIds, function(p2)
		v[p2] = {}
	end)

	return v
end
