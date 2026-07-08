local ParentParent = script.Parent.Parent
local createNavigator = require(script.Parent.createNavigator)
local SwitchRouter = require(ParentParent.routers.SwitchRouter)
local RobloxSwitchView = require(ParentParent.views.RobloxSwitchView)

return function(p1, p2) -- line: 21
	-- upvalues: SwitchRouter (copy), createNavigator (copy), RobloxSwitchView (copy)
	local v7 = SwitchRouter(p1, p2)

	return createNavigator(RobloxSwitchView, v7, p2 or {})
end
