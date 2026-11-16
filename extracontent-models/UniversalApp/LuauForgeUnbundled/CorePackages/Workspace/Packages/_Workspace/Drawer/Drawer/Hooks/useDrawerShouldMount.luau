local GetDrawerVisibleStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Stores/GetDrawerVisibleStore")

local function useDrawerShouldMount()
	return GetDrawerVisibleStore(false).useDrawerShouldMount()
end

return useDrawerShouldMount
