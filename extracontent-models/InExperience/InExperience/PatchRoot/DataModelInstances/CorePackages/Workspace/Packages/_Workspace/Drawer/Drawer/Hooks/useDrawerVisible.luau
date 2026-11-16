local GetDrawerVisibleStore = require(script.Parent.Parent.Stores.GetDrawerVisibleStore)

local function useDrawerVisible()
	return GetDrawerVisibleStore(false).useDrawerVisible()
end

return useDrawerVisible
