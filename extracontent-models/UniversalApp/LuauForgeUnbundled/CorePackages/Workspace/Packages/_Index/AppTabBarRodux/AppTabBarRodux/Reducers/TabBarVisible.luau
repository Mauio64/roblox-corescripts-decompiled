local SetTabBarVisible = require("@game/CorePackages/Workspace/Packages/_Index/AppTabBarRodux/AppTabBarRodux/Actions/SetTabBarVisible")

return function(p2, p3)
	if p2 == nil then
		p2 = false
	end

	if p3.type == SetTabBarVisible.name then
		p2 = p3.isVisible
	end

	return p2
end
