local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

local OverlayActivated = require(parent.Actions.OverlayActivated)
local OverlayDeactivated = require(parent.Actions.OverlayDeactivated)

return Rodux.createReducer(false, {
	[OverlayActivated.name] = function(_: boolean, _): boolean
		return true
	end,
	[OverlayDeactivated.name] = function(_: boolean, _): boolean
		return false
	end
})
