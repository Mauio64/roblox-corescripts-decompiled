local GetDrawerVisibleStore = require(script.Parent.Parent.Stores.GetDrawerVisibleStore)

local function useSetDrawerAnimating() -- line: 3
	-- upvalues: GetDrawerVisibleStore (copy)
	return GetDrawerVisibleStore(false).setDrawerAnimating
end

return useSetDrawerAnimating
