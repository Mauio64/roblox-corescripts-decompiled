local AppTabBarRodux = script:FindFirstAncestor("AppTabBarRodux")
local parent = AppTabBarRodux.Parent

local ArgCheck = require(parent.ArgCheck)
local SetTabBarVisible = require(AppTabBarRodux.Actions.SetTabBarVisible)

return function(p)
	ArgCheck.isType(p, "boolean", "SetTabBarVisibleFromMoments.isVisible")

	return function(object)
		if object:getState().TabBarVisible ~= p then
			object:dispatch(SetTabBarVisible(p))
		end
	end
end
