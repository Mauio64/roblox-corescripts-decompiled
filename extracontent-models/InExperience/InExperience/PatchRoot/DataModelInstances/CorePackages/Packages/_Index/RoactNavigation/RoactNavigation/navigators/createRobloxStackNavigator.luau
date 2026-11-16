local parent = script.Parent.Parent
local createNavigator = require(script.Parent.createNavigator)
local StackRouter = require(parent.routers.StackRouter)
local StackView = require(parent.views.RobloxStackView.StackView)

return function(p, options)
	return createNavigator(StackView, StackRouter(p, options), options or {})
end
