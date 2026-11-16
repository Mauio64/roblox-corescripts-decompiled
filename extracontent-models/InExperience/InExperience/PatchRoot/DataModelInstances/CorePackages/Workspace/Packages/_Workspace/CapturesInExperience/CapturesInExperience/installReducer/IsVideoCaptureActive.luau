local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

local VideoCaptureStarted = require(parent.Actions.VideoCaptureStarted)
local VideoCaptureStopped = require(parent.Actions.VideoCaptureStopped)

require(parent.Enums.CaptureTriggerType)

return Rodux.createReducer({ status = false, triggerType = nil }, {
	[VideoCaptureStarted.name] = function(_, p)
		return { status = true, triggerType = p.triggerType }
	end,
	[VideoCaptureStopped.name] = function(_, p)
		return { status = false, triggerType = p.triggerType }
	end
})
