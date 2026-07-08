local ParentParent = script.Parent.Parent
local InputTypeConstants = require(script.Parent.InputTypeConstants)
local InputTypeMap = require(script.Parent.InputTypeMap)
local getFFlagDebugLuaAppAlwaysUseGamepad = require(ParentParent.SharedFlags).getFFlagDebugLuaAppAlwaysUseGamepad

local function getInputGroup(p1) -- line: 11
	-- upvalues: getFFlagDebugLuaAppAlwaysUseGamepad (copy), InputTypeConstants (copy), InputTypeMap (copy)
	if getFFlagDebugLuaAppAlwaysUseGamepad() then
		return InputTypeConstants.Gamepad
	end

	return InputTypeMap[p1] or InputTypeConstants.None
end

return getInputGroup
