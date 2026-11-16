local parent = script.Parent.Parent
local InputType = require(parent.InputType)
local InputTypeConstants = InputType.InputTypeConstants
local InputType2 = require(parent.InputType)
local getInputGroup = InputType2.getInputGroup

local function isGamepadInput(p): boolean
	return getInputGroup(p) == InputTypeConstants.Gamepad
end

return isGamepadInput
