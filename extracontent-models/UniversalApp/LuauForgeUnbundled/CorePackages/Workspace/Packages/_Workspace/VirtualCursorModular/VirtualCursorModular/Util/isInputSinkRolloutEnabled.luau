local fFlagVirtualCursorInputSink = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/SharedFlags").FFlagVirtualCursorInputSink
local engineFeature = game:GetEngineFeature("InputSinkDefault")

local function isInputSinkRolloutEnabled(p2)
	assert(
		fFlagVirtualCursorInputSink,
		"isInputSinkRolloutEnabled should only be called when VirtualCursorInputSink is enabled"
	)

	return p2 == Enum.RolloutState.Enabled or engineFeature and p2 == Enum.RolloutState.Default
end

return isInputSinkRolloutEnabled
