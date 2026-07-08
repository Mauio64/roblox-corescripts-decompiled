local ParentParent = script.Parent.Parent
local createNavigator = require(script.Parent.createNavigator)
local StackRouter = require(ParentParent.routers.StackRouter)
local StackView = require(ParentParent.views.RobloxStackView.StackView)

return function(p1, p2) -- line: 6
	-- upvalues: StackRouter (copy), createNavigator (copy), StackView (copy)
	local v7 = StackRouter(p1, p2)

	return createNavigator(StackView, v7, p2 or {})
end
