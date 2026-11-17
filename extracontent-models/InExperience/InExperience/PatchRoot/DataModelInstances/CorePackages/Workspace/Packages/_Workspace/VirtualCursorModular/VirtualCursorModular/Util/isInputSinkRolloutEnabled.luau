local parent = script:FindFirstAncestor("VirtualCursorModular").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagVirtualCursorInputSink = SharedFlags.FFlagVirtualCursorInputSink
local engineFeature = game:GetEngineFeature("InputSinkDefault")

local function isInputSinkRolloutEnabled(p)
	assert(
		FFlagVirtualCursorInputSink,
		"isInputSinkRolloutEnabled should only be called when VirtualCursorInputSink is enabled"
	)

	return p == Enum.RolloutState.Enabled or engineFeature and p == Enum.RolloutState.Default
end

return isInputSinkRolloutEnabled
