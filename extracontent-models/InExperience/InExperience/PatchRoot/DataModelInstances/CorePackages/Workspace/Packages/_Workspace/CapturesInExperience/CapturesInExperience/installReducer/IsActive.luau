local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

local CapturesActivated = require(parent.Actions.CapturesActivated)
local CapturesDeactivated = require(parent.Actions.CapturesDeactivated)

return Rodux.createReducer(false, {
	[CapturesActivated.name] = function(_: boolean, _): boolean
		return true
	end,
	[CapturesDeactivated.name] = function(_: boolean, _): boolean
		return false
	end
})
