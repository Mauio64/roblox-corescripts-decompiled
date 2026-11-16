local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

local CapturesCoreGuiDisabled = require(parent.Actions.CapturesCoreGuiDisabled)
local CapturesCoreGuiEnabled = require(parent.Actions.CapturesCoreGuiEnabled)

return Rodux.createReducer(true, {
	[CapturesCoreGuiDisabled.name] = function(_: boolean, _): boolean
		return false
	end,
	[CapturesCoreGuiEnabled.name] = function(_: boolean, _): boolean
		return true
	end
})
