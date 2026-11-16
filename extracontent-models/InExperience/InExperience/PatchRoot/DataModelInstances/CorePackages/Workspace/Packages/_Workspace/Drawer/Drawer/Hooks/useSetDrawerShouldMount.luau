local GetDrawerVisibleStore = require(script.Parent.Parent.Stores.GetDrawerVisibleStore)

local function useSetDrawerShouldMount()
	return GetDrawerVisibleStore(false).setDrawerShouldMount
end

return useSetDrawerShouldMount
