local InputTypeConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/InputType/InputType/InputTypeConstants")
local InputTypeMap = require("@game/CorePackages/Workspace/Packages/_Workspace/InputType/InputType/InputTypeMap")

local getFFlagDebugLuaAppAlwaysUseGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/InputType/SharedFlags").getFFlagDebugLuaAppAlwaysUseGamepad

local function getInputGroup(p2)
	if getFFlagDebugLuaAppAlwaysUseGamepad() then
		return InputTypeConstants.Gamepad
	end

	return InputTypeMap[p2] or InputTypeConstants.None
end

return getInputGroup
