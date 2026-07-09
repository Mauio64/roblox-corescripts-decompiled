local AppTabBarRodux = script:FindFirstAncestor("AppTabBarRodux")
local AppTabBarRoduxParent = AppTabBarRodux.Parent
local ArgCheck = require(AppTabBarRoduxParent.ArgCheck)
local SetTabBarVisible = require(AppTabBarRodux.Actions.SetTabBarVisible)

return function(p1) -- line: 9
	-- upvalues: ArgCheck (copy), SetTabBarVisible (copy)
	ArgCheck.isType(p1, "boolean", "SetTabBarVisibleFromMoments.isVisible")

	return function(p2) -- line: 12
		-- upvalues: p1 (copy), SetTabBarVisible (copy)
		if p2:getState().TabBarVisible ~= p1 then
			p2:dispatch(SetTabBarVisible(p1))
		end
	end
end
