local fFlagVirtualCursorInputSink = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/SharedFlags").FFlagVirtualCursorInputSink

local function getEffectiveInputSink(instance)
	assert(
		fFlagVirtualCursorInputSink,
		"getEffectiveInputSink should only be called when VirtualCursorInputSink is enabled"
	)

	local inputSink = instance.InputSink

	if instance:IsA("GuiButton") or instance:IsA("TextBox") then
		if inputSink == Enum.InputSink.Activate and instance.Active == false then
			return Enum.InputSink.None
		end
	elseif inputSink == Enum.InputSink.None and instance.Active == true then
		return Enum.InputSink.Activate
	end

	return inputSink
end

return getEffectiveInputSink
