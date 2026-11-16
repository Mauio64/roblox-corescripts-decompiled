local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local AppNavBar = require(parent.AppNavBar)
local AppTabBarRodux = require(parent.AppTabBarRodux)
local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore

local SetTabBarVisible = AppTabBarRodux.Actions.SetTabBarVisible

local function useManageBuildNavBarVisibility(p, p2: string)
	local v = useStore()
	local v2 = Navigation.useNavigationFocus()
	local state = p.state
	local v3 = AppNavBar.useNavBarPlacement() ~= AppNavBar.Placement.Bottom or state.routes[state.index].routeName == p2

	React.useEffect(function()
		if v2 and v:getState().TabBarVisible ~= v3 then
			AppNavBar.AppNavTelemetry.logVisibilityStart(v3)
			v:dispatch(SetTabBarVisible(v3))
		end
	end, { v, v2, v3 })
end

return useManageBuildNavBarVisibility
