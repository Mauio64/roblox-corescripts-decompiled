local Workspace = game:GetService("Workspace")

local parent = script:FindFirstAncestor("VirtualCursorModular").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagVirtualCursorInputSink = SharedFlags.FFlagVirtualCursorInputSink

local isInputSinkRolloutEnabled = require(script.Parent.isInputSinkRolloutEnabled)

local function getUsesInputSink(instance, flag: boolean)
	assert(FFlagVirtualCursorInputSink, "getUsesInputSink should only be called when VirtualCursorInputSink is enabled")

	if not flag then
		return isInputSinkRolloutEnabled(Workspace.InputSinkEnabled)
	end

	local layerCollector = instance:FindFirstAncestorWhichIsA("LayerCollector")

	return layerCollector ~= nil
		and layerCollector.Enabled
		and isInputSinkRolloutEnabled(layerCollector.InputSinkEnabled)
end

return getUsesInputSink
