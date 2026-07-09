local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local Constants = require(Modules.LuaApp.Constants)
local SwitchNavigatorVisibleContext = require(Modules.LuaApp.Navigation.SwitchNavigatorVisibleContext)

local function firstOpaqueIndex(p1) -- line: 22
	-- upvalues: AppPageProperties (copy)
	for i = #p1, 1, -1 do
		if not (AppPageProperties[p1[i].routeName] or {}).renderUnderlyingPage then
			return i
		end
	end

	return 1
end
local function indexOfRoute(p2, p3) -- line: 35
	for i, v in ipairs(p2) do
		if p3 == v.routeName then
			return i
		end
	end

	return 0
end
local function wrapWithSwitchVisibility(p4) -- line: 44
	-- upvalues: Roact (copy), Constants (copy), firstOpaqueIndex (copy), SwitchNavigatorVisibleContext (copy)
	local v17 = Roact.Component:extend("rootNavigatorWrapper")

	function v17.render(p5) -- line: 47
		-- upvalues: Constants (copy), firstOpaqueIndex (copy), Roact (copy), SwitchNavigatorVisibleContext (copy), p4 (copy)
		local routes = p5.props.navigation.state.routes
		local TempRnSwitchNavigatorName = Constants.TempRnSwitchNavigatorName
		local g24 = nil
		local v23 = nil

		for i, v in ipairs(routes) do
			if TempRnSwitchNavigatorName == v.routeName then
				v23 = i
				g24 = true
			end

			if g24 then
				break
			end
		end

		if not g24 then
			v23 = 0
		end

		g24 = false

		local v25 = v23 >= firstOpaqueIndex(routes)

		return Roact.createElement(SwitchNavigatorVisibleContext.Provider, {
			value = v25
		}, {
			Navigator = Roact.createElement(p4, p5.props)
		})
	end

	v17.router = p4.router

	return v17
end

return wrapWithSwitchVisibility
