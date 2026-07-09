local Parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local GetDrawerVisibleStore = require(Parent.Drawer).Stores.GetDrawerVisibleStore

return function(p1) -- line: 6
	-- upvalues: GetDrawerVisibleStore (copy)
	return GetDrawerVisibleStore(p1).getDrawerVisible(p1)
end
