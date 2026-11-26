local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local AppTabBarRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/AppTabBarRodux")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RoactUtils").Hooks.RoactRodux.useDispatch

local setTabBarVisible = AppTabBarRodux.Actions.SetTabBarVisible

local function useHideTabBarWhileOpen(p2)
	local v5 = useDispatch()

	React.useEffect(function()
		if p2 then
			v5(setTabBarVisible(false))
		end

		return function()
			if p2 then
				v5(setTabBarVisible(true))
			end
		end
	end, { p2, v5 })
end

return useHideTabBarWhileOpen
