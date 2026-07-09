local Parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local GetDrawerVisibleStore = require(Parent.Drawer).Stores.GetDrawerVisibleStore

return function(b1: boolean) -- line: 6
	-- upvalues: GetDrawerVisibleStore (copy)
	GetDrawerVisibleStore(false).setDrawerVisible(b1)
end
