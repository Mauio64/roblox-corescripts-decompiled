local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Types = ParentParent.Types
local Rodux = require(ParentParentParent.Rodux)

require(Types.ReducerTypes)
require(Types.ActionTypes)

local RequestSent = require(ParentParent.Actions).RequestSent
local Dash = require(ParentParentParent.Dash)
local t1 = {}

return function(_) -- line: 13
	-- upvalues: Rodux (copy), t1 (copy), RequestSent (copy), Dash (copy)
	return Rodux.createReducer(t1, {
		[RequestSent.name] = function(p2, p3) -- line: 15
			-- upvalues: Dash (copy)
			return Dash.join(p2, {
				[p3.payload.id] = true
			})
		end
	})
end
