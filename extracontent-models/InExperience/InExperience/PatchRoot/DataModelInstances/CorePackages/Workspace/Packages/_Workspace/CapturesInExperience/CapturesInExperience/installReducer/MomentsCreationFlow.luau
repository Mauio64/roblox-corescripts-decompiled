local parent = script.Parent.Parent
local parent2 = parent.Parent

local Cryo = require(parent2.Cryo)
local Rodux = require(parent2.Rodux)

require(parent.Types)

local MomentsCreationFlowClosed = require(parent.Actions.MomentsCreationFlowClosed)
local MomentsCreationFlowOpened = require(parent.Actions.MomentsCreationFlowOpened)

local v = { IsOpen = false, Capture = nil, SessionId = nil }

return Rodux.createReducer(v, {
	[MomentsCreationFlowOpened.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			IsOpen = true,
			Capture = p2.capture,
			SessionId = p2.sessionId
		})
	end,
	[MomentsCreationFlowClosed.name] = function(_, _)
		return v
	end
})
