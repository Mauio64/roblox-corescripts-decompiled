local Workspace = game:GetService("Workspace")

local fFlagVirtualCursorInputSink = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/SharedFlags").FFlagVirtualCursorInputSink

local isInputSinkRolloutEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Util/isInputSinkRolloutEnabled")

local function getUsesInputSink(instance, p2)
	assert(
		fFlagVirtualCursorInputSink,
		"getUsesInputSink should only be called when VirtualCursorInputSink is enabled"
	)

	if not p2 then
		return isInputSinkRolloutEnabled(Workspace.InputSinkEnabled)
	end

	local layerCollector = instance:FindFirstAncestorWhichIsA("LayerCollector")

	return layerCollector ~= nil and layerCollector.Enabled and isInputSinkRolloutEnabled(layerCollector.InputSinkEnabled)
end

return getUsesInputSink
