local GetDrawerVisibleStore = require(script.Parent.Parent.Stores.GetDrawerVisibleStore)

local function useDrawerShouldMount() -- line: 3
	-- upvalues: GetDrawerVisibleStore (copy)
	return GetDrawerVisibleStore(false).useDrawerShouldMount()
end

return useDrawerShouldMount
