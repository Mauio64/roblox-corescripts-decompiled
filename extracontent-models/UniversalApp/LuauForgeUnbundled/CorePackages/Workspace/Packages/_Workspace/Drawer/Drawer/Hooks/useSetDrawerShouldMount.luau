local GetDrawerVisibleStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Stores/GetDrawerVisibleStore")

local function useSetDrawerShouldMount()
	return GetDrawerVisibleStore(false).setDrawerShouldMount
end

return useSetDrawerShouldMount
