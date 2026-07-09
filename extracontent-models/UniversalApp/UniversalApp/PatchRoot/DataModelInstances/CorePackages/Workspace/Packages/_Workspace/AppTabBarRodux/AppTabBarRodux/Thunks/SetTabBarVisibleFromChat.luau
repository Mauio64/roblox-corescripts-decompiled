local AppTabBarRodux = script:FindFirstAncestor("AppTabBarRodux")
local AppTabBarRoduxParent = AppTabBarRodux.Parent
local ArgCheck = require(AppTabBarRoduxParent.ArgCheck)
local SetTabBarVisible = require(AppTabBarRodux.Actions.SetTabBarVisible)

return function(p1) -- line: 7
	-- upvalues: ArgCheck (copy), SetTabBarVisible (copy)
	ArgCheck.isType(p1, "boolean", "SetTabBarVisibleFromChat.isVisible")

	return function(p2) -- line: 10
		-- upvalues: p1 (copy), SetTabBarVisible (copy)
		local v7 = p2:getState()

		if not v7.ChatAppReducer.ToggleChatPaused and v7.TabBarVisible ~= p1 then
			p2:dispatch(SetTabBarVisible(p1))
		end
	end
end
