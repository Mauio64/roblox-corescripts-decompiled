local AppTabBarRodux = script:FindFirstAncestor("AppTabBarRodux")
local SetTabBarVisible = require(AppTabBarRodux.Actions.SetTabBarVisible)

return function(b1: boolean?, p1) -- line: 6
	-- upvalues: SetTabBarVisible (copy)
	if b1 == nil then
		b1 = false
	end

	if p1.type == SetTabBarVisible.name then
		b1 = p1.isVisible
	end

	return b1
end
