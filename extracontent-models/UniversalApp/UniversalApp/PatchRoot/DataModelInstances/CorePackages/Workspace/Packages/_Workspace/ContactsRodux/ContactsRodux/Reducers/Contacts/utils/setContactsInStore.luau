local ParentParent = script.Parent.Parent.Parent.Parent
local Types = ParentParent.Types

require(Types.ReducerTypes)

local ParentParentParent = ParentParent.Parent

require(Types.ActionTypes)

local Dash = require(ParentParentParent.Dash)

return function(p1) -- line: 8
	-- upvalues: Dash (copy)
	local userContactIds = p1.responseBody.userContactIds
	local t1 = {}

	Dash.forEach(userContactIds, function(p2) -- line: 12
		-- upvalues: t1 (copy)
		t1[p2] = {}
	end)

	return t1
end
