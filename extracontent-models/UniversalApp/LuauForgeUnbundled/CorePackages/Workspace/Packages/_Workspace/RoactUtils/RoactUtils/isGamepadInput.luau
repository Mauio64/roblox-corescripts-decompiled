local inputTypeConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/InputType").InputTypeConstants
local getInputGroup = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/InputType").getInputGroup

local function isGamepadInput(p2): boolean
	return getInputGroup(p2) == inputTypeConstants.Gamepad
end

return isGamepadInput
