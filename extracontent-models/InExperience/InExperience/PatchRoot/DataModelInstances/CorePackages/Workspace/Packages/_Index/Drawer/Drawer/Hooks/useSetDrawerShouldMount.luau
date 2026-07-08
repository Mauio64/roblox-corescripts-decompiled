local GetDrawerVisibleStore = require(script.Parent.Parent.Stores.GetDrawerVisibleStore)

local function useSetDrawerShouldMount() -- line: 3
	-- upvalues: GetDrawerVisibleStore (copy)
	return GetDrawerVisibleStore(false).setDrawerShouldMount
end

return useSetDrawerShouldMount
