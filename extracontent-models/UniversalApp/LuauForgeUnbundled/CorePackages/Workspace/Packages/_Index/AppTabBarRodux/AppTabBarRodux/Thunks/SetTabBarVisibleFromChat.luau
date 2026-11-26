local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AppTabBarRodux/ArgCheck")
local SetTabBarVisible = require("@game/CorePackages/Workspace/Packages/_Index/AppTabBarRodux/AppTabBarRodux/Actions/SetTabBarVisible")

return function(p2)
	ArgCheck.isType(p2, "boolean", "SetTabBarVisibleFromChat.isVisible")

	return function(object)
		if object:getState().TabBarVisible ~= p2 then
			object:dispatch(SetTabBarVisible(p2))
		end
	end
end
