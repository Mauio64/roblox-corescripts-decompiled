local ParentParent = script.Parent.Parent
local createNavigator = require(script.Parent.createNavigator)
local SwitchRouter = require(ParentParent.routers.SwitchRouter)
local SwitchView = require(ParentParent.views.SwitchView.SwitchView)

return function(p1, p2) -- line: 7
	-- upvalues: SwitchRouter (copy), createNavigator (copy), SwitchView (copy)
	if p2 == nil then
		p2 = {}
	end

	local v7 = SwitchRouter(p1, p2)

	return createNavigator(SwitchView, v7, p2)
end
