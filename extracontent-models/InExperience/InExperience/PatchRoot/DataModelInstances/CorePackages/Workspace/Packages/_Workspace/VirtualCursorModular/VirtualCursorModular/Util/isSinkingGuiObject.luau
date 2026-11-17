local getEffectiveInputSink = require(script.Parent.getEffectiveInputSink)

local parent = script:FindFirstAncestor("VirtualCursorModular").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagVirtualCursorInputSink = SharedFlags.FFlagVirtualCursorInputSink

local function isSinkingGuiObject(data, flag: boolean?)
	if FFlagVirtualCursorInputSink and flag then
		local effectiveInputSink = getEffectiveInputSink(data)
		return data.Visible
			and (effectiveInputSink == Enum.InputSink.All or effectiveInputSink == Enum.InputSink.Activate)
	end

	return data.Visible and data.Active and data.Interactable
end

return isSinkingGuiObject
