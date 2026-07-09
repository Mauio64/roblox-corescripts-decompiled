local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local VideoCaptureStarted = require(ParentParent.Actions.VideoCaptureStarted)
local VideoCaptureStopped = require(ParentParent.Actions.VideoCaptureStopped)

require(ParentParent.Enums.CaptureTriggerType)

local t1 = {
	status = false,
	triggerType = nil
}

return Rodux.createReducer(t1, {
	[VideoCaptureStarted.name] = function(_: {[any]: any}, p1) -- line: 22
		return {
			status = true,
			triggerType = p1.triggerType
		}
	end,
	[VideoCaptureStopped.name] = function(_: {[any]: any}, p2) -- line: 29
		return {
			status = false,
			triggerType = p2.triggerType
		}
	end
})
