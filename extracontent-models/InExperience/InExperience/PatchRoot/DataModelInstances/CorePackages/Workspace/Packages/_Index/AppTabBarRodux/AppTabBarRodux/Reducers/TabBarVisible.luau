local AppTabBarRodux = script:FindFirstAncestor("AppTabBarRodux")
local SetTabBarVisible = require(AppTabBarRodux.Actions.SetTabBarVisible)

return function(flag: boolean?, p)
	if flag == nil then
		flag = false
	end

	if p.type == SetTabBarVisible.name then
		flag = p.isVisible
	end

	return flag
end
