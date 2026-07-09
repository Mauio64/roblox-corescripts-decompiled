local Parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local useProperty = require(Parent.GuiObjectUtils).useProperty

local function useCurrentCamera() -- line: 5
	-- upvalues: useProperty (copy)
	return useProperty(workspace, "CurrentCamera")
end

return useCurrentCamera
