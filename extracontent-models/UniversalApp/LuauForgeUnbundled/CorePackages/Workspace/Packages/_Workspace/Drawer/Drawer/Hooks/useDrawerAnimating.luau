local GetDrawerVisibleStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Stores/GetDrawerVisibleStore")

local function useDrawerAnimating()
	return GetDrawerVisibleStore(false).useDrawerAnimating()
end

return useDrawerAnimating
