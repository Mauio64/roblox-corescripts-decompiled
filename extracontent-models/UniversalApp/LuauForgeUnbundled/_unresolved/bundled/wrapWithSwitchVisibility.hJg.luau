local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local module = require("@luauforge/bundled/dDE")
local module2 = require("@luauforge/bundled/dwA")
local module3 = require("@luauforge/bundled/geL")

local function firstOpaqueIndex(routes)
	for i = #routes, 1, -1 do
		if not (module[routes[i].routeName] or {}).renderUnderlyingPage then
			return i
		end
	end

	return 1
end

local function indexOfRoute(list, p2)
	for i, item in ipairs(list) do
		if item.routeName == p2 then
			return i
		end
	end

	return 0
end

local function wrapWithSwitchVisibility(p2)
	local extended = Roact.Component:extend("rootNavigatorWrapper")

	function extended.render(p3)
		local routes = p3.props.navigation.state.routes
		local tempRnSwitchNavigatorName = module2.TempRnSwitchNavigatorName
		local v5 = nil
		local flag = true

		for i, route in ipairs(routes) do
			if route.routeName == tempRnSwitchNavigatorName then
				v5 = i
				flag = false
				break
			end
		end

		if flag then
			v5 = 0
		end

		local v6 = firstOpaqueIndex(routes) <= v5

		return Roact.createElement(module3.Provider, { value = v6 }, {
			Navigator = Roact.createElement(p2, p3.props)
		})
	end

	extended.router = p2.router
	return extended
end

return wrapWithSwitchVisibility
