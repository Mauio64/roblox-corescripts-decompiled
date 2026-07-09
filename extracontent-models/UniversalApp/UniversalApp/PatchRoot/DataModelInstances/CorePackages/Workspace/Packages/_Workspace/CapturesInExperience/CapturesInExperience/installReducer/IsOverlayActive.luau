local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local OverlayActivated = require(ParentParent.Actions.OverlayActivated)
local OverlayDeactivated = require(ParentParent.Actions.OverlayDeactivated)

return Rodux.createReducer(false, {
	[OverlayActivated.name] = function(_: boolean, _: {[any]: any}) -- line: 14
		return true
	end,
	[OverlayDeactivated.name] = function(_: boolean, _: {[any]: any}) -- line: 18
		return false
	end
})
