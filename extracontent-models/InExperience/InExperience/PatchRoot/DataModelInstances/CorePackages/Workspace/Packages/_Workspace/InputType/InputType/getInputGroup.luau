local parent = script.Parent.Parent
local InputTypeConstants = require(script.Parent.InputTypeConstants)
local InputTypeMap = require(script.Parent.InputTypeMap)

local SharedFlags = require(parent.SharedFlags)
local getFFlagDebugLuaAppAlwaysUseGamepad = SharedFlags.getFFlagDebugLuaAppAlwaysUseGamepad

local function getInputGroup(p)
	if getFFlagDebugLuaAppAlwaysUseGamepad() then
		return InputTypeConstants.Gamepad
	end

	return InputTypeMap[p] or InputTypeConstants.None
end

return getInputGroup
