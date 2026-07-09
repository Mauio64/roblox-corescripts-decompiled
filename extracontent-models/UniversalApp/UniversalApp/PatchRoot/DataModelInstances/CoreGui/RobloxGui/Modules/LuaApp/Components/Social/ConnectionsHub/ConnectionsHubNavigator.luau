local CorePackages = game:GetService("CorePackages")
local Packages = CorePackages.Packages
local React = require(Packages.React)
local RoactNavigation = require(Packages.RoactNavigation)
local ConnectionsHub = require(CorePackages.Workspace.Packages.ConnectionsHub).ConnectionsHub
local ConnectionsHubRouter = require(script.Parent.ConnectionsHubRouter)
local TabConfig = require(script.Parent.TabConfig)
local v8 = RoactNavigation.createRobloxSwitchNavigator(ConnectionsHubRouter, {
	resetOnBlur = false,
	keepVisitedScreensMounted = true,
	backBehavior = RoactNavigation.BackBehavior.None
})

local function v9(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), v8 (copy), ConnectionsHub (copy), TabConfig (copy)
	local navigation = t1.navigation
	local v13 = React.useCallback(function() -- line: 25
		-- upvalues: React (copy), v8 (copy), navigation (copy)
		return React.createElement(v8, {
			navigation = navigation
		})
	end, { navigation })

	return React.createElement(ConnectionsHub, {
		renderNavigator = v13,
		tabConfig = TabConfig
	})
end

local v10 = React.PureComponent:extend("ClassWrapper")

function v10.render(p1) -- line: 40
	-- upvalues: React (copy), v9 (copy)
	return React.createElement(v9, p1.props)
end

v10.router = v8.router

return v10
