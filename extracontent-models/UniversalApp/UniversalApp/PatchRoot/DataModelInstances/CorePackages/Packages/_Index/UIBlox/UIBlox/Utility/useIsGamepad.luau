local parent = script.Parent
local parent2 = parent.Parent

local InputType = require(parent2.Enums.InputType)
local useInputType = require(parent.useInputType)

local function useIsGamepad(): boolean
	return useInputType() == InputType.Gamepad
end

return useIsGamepad
