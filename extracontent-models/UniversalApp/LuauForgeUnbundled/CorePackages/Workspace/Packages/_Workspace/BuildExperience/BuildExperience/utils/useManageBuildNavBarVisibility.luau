local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Navigation")
local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AppNavBar")
local AppTabBarRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AppTabBarRodux")
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactUtils").Hooks.RoactRodux.useStore

local setTabBarVisible = AppTabBarRodux.Actions.SetTabBarVisible

local function useManageBuildNavBarVisibility(p2, p3)
	local v5 = useStore()
	local v6 = Navigation.useNavigationFocus()
	local state = p2.state
	local v7 = AppNavBar.useNavBarPlacement() ~= AppNavBar.Placement.Bottom
		or state.routes[state.index].routeName == p3

	React.useEffect(function()
		if v6 and v5:getState().TabBarVisible ~= v7 then
			AppNavBar.AppNavTelemetry.logVisibilityStart(v7)
			v5:dispatch(setTabBarVisible(v7))
		end
	end, { v5, v6, v7 })
end

return useManageBuildNavBarVisibility
