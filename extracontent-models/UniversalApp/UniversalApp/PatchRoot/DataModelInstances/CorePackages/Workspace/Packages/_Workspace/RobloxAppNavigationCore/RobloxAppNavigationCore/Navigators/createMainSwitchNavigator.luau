local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent
local React = require(Parent.React)
local RoactNavigation = require(Parent.RoactNavigation)

require(Parent.Navigation)

local CurrentTabContext = require(Parent.RobloxAppNavigation).CurrentTabContext
local createAdaptiveSwitchNavigator = require(script.Parent.createAdaptiveSwitchNavigator)

local function createMainSwitchNavigator(p1) -- line: 16
	-- upvalues: createAdaptiveSwitchNavigator (copy), RoactNavigation (copy), React (copy), CurrentTabContext (copy)
	local v8 = createAdaptiveSwitchNavigator(p1, {
		keepVisitedScreensMounted = true,
		resetOnBlur = false,
		backBehavior = RoactNavigation.BackBehavior.InitialRoute
	})
	local v9 = React.Component:extend("SwitchNavigatorWrapper")

	v9.router = v8.router

	function v9.render(p2) -- line: 26
		-- upvalues: React (copy), CurrentTabContext (copy), v8 (copy)
		local state = p2.props.navigation.state
		local v12 = state.routes[state.index]

		return React.createElement(CurrentTabContext.Provider, {
			value = v12.routeName
		}, {
			Navigator = React.createElement(v8, p2.props)
		})
	end

	return v9
end

return createMainSwitchNavigator
