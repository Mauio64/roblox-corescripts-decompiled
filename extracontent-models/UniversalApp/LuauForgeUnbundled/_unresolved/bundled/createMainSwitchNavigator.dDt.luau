local React = require("@game/CorePackages/Workspace/Packages/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/RoactNavigation")
require("@luauforge/bundled/dCC")
local currentTabContext = require("@luauforge/bundled/dDu").CurrentTabContext

local SwitchView = require("@game/CorePackages/Packages/_Index/RoactNavigation/RoactNavigation/views/SwitchView/SwitchView")
local SwitchRouter = require("@game/CorePackages/Packages/_Index/RoactNavigation/RoactNavigation/routers/SwitchRouter")

local function createMainSwitchNavigator(p2)
	local v5 = {
		keepVisitedScreensMounted = true,
		resetOnBlur = false,
		backBehavior = RoactNavigation.BackBehavior.InitialRoute
	}

	local v6 = SwitchRouter(p2, v5)

	local navigator = RoactNavigation.createNavigator(SwitchView, v6, v5)

	local mainSwitchNavigator = React.Component:extend("SwitchNavigatorWrapper")
	mainSwitchNavigator.router = navigator.router

	function mainSwitchNavigator.render(p3)
		local state = p3.props.navigation.state
		local route = state.routes[state.index]

		return React.createElement(currentTabContext.Provider, {
			value = route.routeName
		}, {
			Navigator = React.createElement(navigator, p3.props)
		})
	end

	return mainSwitchNavigator
end

return createMainSwitchNavigator
