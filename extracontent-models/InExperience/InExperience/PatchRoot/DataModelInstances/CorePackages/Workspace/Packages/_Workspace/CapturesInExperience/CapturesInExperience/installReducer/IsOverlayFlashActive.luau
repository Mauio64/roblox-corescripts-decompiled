local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

local OverlayFlashActivated = require(parent.Actions.OverlayFlashActivated)
local OverlayFlashDeactivated = require(parent.Actions.OverlayFlashDeactivated)

return Rodux.createReducer(false, {
	[OverlayFlashActivated.name] = function(_: boolean, _): boolean
		return true
	end,
	[OverlayFlashDeactivated.name] = function(_: boolean, _): boolean
		return false
	end
})
