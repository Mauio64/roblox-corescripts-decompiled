local GetDrawerVisibleStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Stores/GetDrawerVisibleStore")

local function useSetDrawerVisible()
	return GetDrawerVisibleStore(false).setDrawerVisible
end

return useSetDrawerVisible
