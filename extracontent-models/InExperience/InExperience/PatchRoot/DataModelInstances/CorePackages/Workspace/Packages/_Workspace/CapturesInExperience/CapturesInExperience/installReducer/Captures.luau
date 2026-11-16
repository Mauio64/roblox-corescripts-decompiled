local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

local CapturesRetrieved = require(parent.Actions.CapturesRetrieved)
require(parent.Types)

return Rodux.createReducer({}, {
	[CapturesRetrieved.name] = function(_, p)
		return p.captures
	end
})
