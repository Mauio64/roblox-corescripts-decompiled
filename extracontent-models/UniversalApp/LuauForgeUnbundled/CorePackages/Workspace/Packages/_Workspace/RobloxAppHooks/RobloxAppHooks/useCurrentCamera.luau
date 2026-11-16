local useProperty = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/GuiObjectUtils").useProperty

local function useCurrentCamera()
	return useProperty(workspace, "CurrentCamera")
end

return useCurrentCamera
