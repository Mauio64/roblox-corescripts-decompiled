local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local OverlayFlashActivated = require(ParentParent.Actions.OverlayFlashActivated)
local OverlayFlashDeactivated = require(ParentParent.Actions.OverlayFlashDeactivated)

return Rodux.createReducer(false, {
	[OverlayFlashActivated.name] = function(_: boolean, _: {[any]: any}) -- line: 14
		return true
	end,
	[OverlayFlashDeactivated.name] = function(_: boolean, _: {[any]: any}) -- line: 18
		return false
	end
})
