local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local types = parent.Types
local Rodux = require(parent2.Rodux)
require(types.ReducerTypes)
require(types.ActionTypes)
local Actions = require(parent.Actions)
local RequestSent = Actions.RequestSent
local Dash = require(parent2.Dash)

local v = {}

return function(_)
	return Rodux.createReducer(v, {
		[RequestSent.name] = function(p, p2)
			return Dash.join(p, { [p2.payload.id] = true })
		end
	})
end
