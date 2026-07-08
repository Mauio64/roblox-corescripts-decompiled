local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local CapturesActivated = require(ParentParent.Actions.CapturesActivated)
local CapturesDeactivated = require(ParentParent.Actions.CapturesDeactivated)

return Rodux.createReducer(false, {
	[CapturesActivated.name] = function(_: boolean, _: {[any]: any}) -- line: 14
		return true
	end,
	[CapturesDeactivated.name] = function(_: boolean, _: {[any]: any}) -- line: 18
		return false
	end
})
