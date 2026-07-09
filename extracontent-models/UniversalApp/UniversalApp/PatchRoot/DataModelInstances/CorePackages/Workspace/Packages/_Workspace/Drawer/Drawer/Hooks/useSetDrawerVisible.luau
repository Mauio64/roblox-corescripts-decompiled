local GetDrawerVisibleStore = require(script.Parent.Parent.Stores.GetDrawerVisibleStore)

local function useSetDrawerVisible() -- line: 3
	-- upvalues: GetDrawerVisibleStore (copy)
	return GetDrawerVisibleStore(false).setDrawerVisible
end

return useSetDrawerVisible
