local GetDrawerVisibleStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Stores/GetDrawerVisibleStore")

local function useDrawerVisible()
	return GetDrawerVisibleStore(false).useDrawerVisible()
end

return useDrawerVisible
