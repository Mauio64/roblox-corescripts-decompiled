local GetDrawerVisibleStore = require(script.Parent.Parent.Stores.GetDrawerVisibleStore)

local function useDrawerAnimating()
	return GetDrawerVisibleStore(false).useDrawerAnimating()
end

return useDrawerAnimating
