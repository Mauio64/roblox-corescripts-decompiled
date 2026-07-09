local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local CapturesCoreGuiDisabled = require(ParentParent.Actions.CapturesCoreGuiDisabled)
local CapturesCoreGuiEnabled = require(ParentParent.Actions.CapturesCoreGuiEnabled)

return Rodux.createReducer(true, {
	[CapturesCoreGuiDisabled.name] = function(_: boolean, _: {[any]: any}) -- line: 14
		return false
	end,
	[CapturesCoreGuiEnabled.name] = function(_: boolean, _: {[any]: any}) -- line: 18
		return true
	end
})
