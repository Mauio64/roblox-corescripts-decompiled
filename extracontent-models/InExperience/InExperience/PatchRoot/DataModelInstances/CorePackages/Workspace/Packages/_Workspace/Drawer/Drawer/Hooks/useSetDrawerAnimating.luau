local GetDrawerVisibleStore = require(script.Parent.Parent.Stores.GetDrawerVisibleStore)

local function useSetDrawerAnimating()
	return GetDrawerVisibleStore(false).setDrawerAnimating
end

return useSetDrawerAnimating
