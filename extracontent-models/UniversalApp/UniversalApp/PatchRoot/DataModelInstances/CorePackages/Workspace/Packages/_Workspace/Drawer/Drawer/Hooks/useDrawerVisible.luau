local GetDrawerVisibleStore = require(script.Parent.Parent.Stores.GetDrawerVisibleStore)

local function useDrawerVisible() -- line: 3
	-- upvalues: GetDrawerVisibleStore (copy)
	return GetDrawerVisibleStore(false).useDrawerVisible()
end

return useDrawerVisible
