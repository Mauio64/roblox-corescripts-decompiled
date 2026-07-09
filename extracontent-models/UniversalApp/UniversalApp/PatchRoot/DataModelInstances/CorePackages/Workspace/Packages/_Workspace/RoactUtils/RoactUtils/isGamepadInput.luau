local ParentParent = script.Parent.Parent
local InputTypeConstants = require(ParentParent.InputType).InputTypeConstants
local getInputGroup = require(ParentParent.InputType).getInputGroup

local function isGamepadInput(p1) -- line: 5
	-- upvalues: getInputGroup (copy), InputTypeConstants (copy)
	return getInputGroup(p1) == InputTypeConstants.Gamepad
end

return isGamepadInput
