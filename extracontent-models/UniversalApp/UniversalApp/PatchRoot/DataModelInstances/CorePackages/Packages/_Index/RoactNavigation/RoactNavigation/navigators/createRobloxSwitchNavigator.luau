local parent = script.Parent.Parent
local createNavigator = require(script.Parent.createNavigator)
local SwitchRouter = require(parent.routers.SwitchRouter)
local RobloxSwitchView = require(parent.views.RobloxSwitchView)

return function(p, options)
	return createNavigator(RobloxSwitchView, SwitchRouter(p, options), options or {})
end
