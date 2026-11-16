local parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local Drawer = require(parent.Drawer)
local GetDrawerVisibleStore = Drawer.Stores.GetDrawerVisibleStore

return function(p)
	return GetDrawerVisibleStore(p).getDrawerVisible(p)
end
