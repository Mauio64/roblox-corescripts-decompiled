local GetDrawerVisibleStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Stores/GetDrawerVisibleStore")

local function useSetDrawerAnimating()
	return GetDrawerVisibleStore(false).setDrawerAnimating
end

return useSetDrawerAnimating
