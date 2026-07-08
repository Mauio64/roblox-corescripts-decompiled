local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local InputType = require(scriptParentParent.Enums.InputType)
local useInputType = require(scriptParent.useInputType)

local function useIsMouseAndKeyboard() -- line: 11
	-- upvalues: useInputType (copy), InputType (copy)
	return useInputType() == InputType.MouseAndKeyboard
end

return useIsMouseAndKeyboard
