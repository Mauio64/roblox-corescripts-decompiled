local parent = script.Parent
local parent2 = parent.Parent

local InputType = require(parent2.Enums.InputType)
local useInputType = require(parent.useInputType)

local function useIsMouseAndKeyboard(): boolean
	return useInputType() == InputType.MouseAndKeyboard
end

return useIsMouseAndKeyboard
