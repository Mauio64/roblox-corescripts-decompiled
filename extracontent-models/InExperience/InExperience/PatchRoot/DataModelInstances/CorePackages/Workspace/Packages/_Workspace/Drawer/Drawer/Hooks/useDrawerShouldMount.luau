local GetDrawerVisibleStore = require(script.Parent.Parent.Stores.GetDrawerVisibleStore)

local function useDrawerShouldMount()
	return GetDrawerVisibleStore(false).useDrawerShouldMount()
end

return useDrawerShouldMount
