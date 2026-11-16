local parent = script.Parent.Parent
local createNavigator = require(script.Parent.createNavigator)
local SwitchRouter = require(parent.routers.SwitchRouter)
local SwitchView = require(parent.views.SwitchView.SwitchView)

return function(p, p2)
	local v = p2 == nil and {} or p2

	return createNavigator(SwitchView, SwitchRouter(p, v), v)
end
