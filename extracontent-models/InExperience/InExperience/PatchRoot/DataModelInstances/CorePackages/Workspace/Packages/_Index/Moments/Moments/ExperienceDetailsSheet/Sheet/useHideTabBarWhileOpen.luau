local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
local AppTabBarRodux = require(parent.AppTabBarRodux)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local SetTabBarVisible = AppTabBarRodux.Actions.SetTabBarVisible

local function useHideTabBarWhileOpen(flag: boolean)
	local v = useDispatch()

	React.useEffect(function()
		if flag then
			v(SetTabBarVisible(false))
		end

		return function()
			if flag then
				v(SetTabBarVisible(true))
			end
		end
	end, { flag, v })
end

return useHideTabBarWhileOpen
