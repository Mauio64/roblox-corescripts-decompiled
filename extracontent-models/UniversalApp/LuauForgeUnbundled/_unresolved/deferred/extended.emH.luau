local CorePackages = game:GetService("CorePackages")
local packages = CorePackages.Packages

local React = require(packages.React)
local RoactNavigation = require(packages.RoactNavigation)

local connectionsHub = require("@luauforge/deferred/emI").ConnectionsHub

local module = require("@luauforge/deferred/enh")
local module2 = require("@luauforge/deferred/eni")

local robloxSwitchNavigator = RoactNavigation.createRobloxSwitchNavigator(module, {
	resetOnBlur = false,
	keepVisitedScreensMounted = true,
	backBehavior = RoactNavigation.BackBehavior.None
})

local function fn(p2)
	local navigation = p2.navigation

	local v5 = React.useCallback(function()
		return React.createElement(robloxSwitchNavigator, { navigation = navigation })
	end, { navigation })

	return React.createElement(connectionsHub, {
		renderNavigator = v5,
		tabConfig = module2
	})
end

local extended = React.PureComponent:extend("ClassWrapper")

function extended.render(p2)
	return React.createElement(fn, p2.props)
end

extended.router = robloxSwitchNavigator.router

return extended
