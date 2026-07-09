local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local AppRouterParamsContext = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.AppRouterParamsContext)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local isRootRouteInRN = require(Modules.LuaApp.Navigation.isRootRouteInRN)

return function(p1) -- line: 20
	-- upvalues: Roact (copy), NavigationUtils (copy), isRootRouteInRN (copy), Cryo (copy), AppRouterParamsContext (copy)
	local v9 = Roact.PureComponent:extend("AppRouterParams")

	function v9.init(p2) -- line: 23
		-- upvalues: NavigationUtils (copy), isRootRouteInRN (copy)
		local navigation = p2.props.navigation
		local v12 = NavigationUtils.getRootNavigation(navigation)

		if isRootRouteInRN(v12.state) and p2.props.params then
			navigation.setParams(p2.props.params)
		end
	end
	function v9.render(p3) -- line: 33
		-- upvalues: Roact (copy), p1 (copy), Cryo (copy)
		if p3.props.navigation.state.params == nil then
			return nil
		end

		return Roact.createElement(p1, Cryo.Dictionary.join(p3.props, {
			params = Cryo.None
		}))
	end

	return function(p4) -- line: 47
		-- upvalues: Roact (copy), AppRouterParamsContext (copy), Cryo (copy), v9 (copy)
		return Roact.createElement(AppRouterParamsContext.Consumer, {
			render = function(p5) -- line: 49
				-- upvalues: p4 (copy), Cryo (copy), Roact (copy), v9 (copy)
				if p5.setNavigationForTests then
					p5.setNavigationForTests(p4.navigation)
					p5 = Cryo.Dictionary.join(p5, {
						setNavigationForTests = Cryo.None
					})
				end

				local v16 = Cryo.Dictionary.join(p4, {
					params = p5
				})

				return Roact.createElement(v9, v16)
			end
		})
	end
end
