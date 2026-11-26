local getEffectiveInputSink = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Util/getEffectiveInputSink")

local fFlagVirtualCursorInputSink = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/SharedFlags").FFlagVirtualCursorInputSink

local function isSinkingGuiObject(data, p2)
	if fFlagVirtualCursorInputSink and p2 then
		local v5 = getEffectiveInputSink(data)
		return data.Visible and (v5 == Enum.InputSink.All or v5 == Enum.InputSink.Activate)
	end

	return data.Visible and data.Active and data.Interactable
end

return isSinkingGuiObject
