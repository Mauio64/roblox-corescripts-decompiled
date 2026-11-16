local parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local GuiObjectUtils = require(parent.GuiObjectUtils)
local useProperty = GuiObjectUtils.useProperty

local function useCurrentCamera()
	return useProperty(workspace, "CurrentCamera")
end

return useCurrentCamera
