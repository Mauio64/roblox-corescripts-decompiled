local GetDrawerVisibleStore = require(script.Parent.Parent.Stores.GetDrawerVisibleStore)

local function useSetDrawerVisible()
	return GetDrawerVisibleStore(false).setDrawerVisible
end

return useSetDrawerVisible
