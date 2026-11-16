local NavigationActions = require(script.Parent.Parent.NavigationActions)
local invariant = require(script.Parent.Parent.utils.invariant)

return function(p)
	return {
		goBack = function(p2)
			if p2 == nil and p.key then
				invariant(type(p.key) == "string", ".goBack(): key should be a string")
				p2 = p.key
			end

			return NavigationActions.back({ key = p2 })
		end,
		navigate = function(routeName, params, action)
			if type(routeName) == "string" then
				return NavigationActions.navigate({
					routeName = routeName,
					params = params,
					action = action
				})
			end

			invariant(type(routeName) == "table", ".navigate(): navigateTo must be a string or table")
			invariant(params == nil, ".navigate(): params can only be provided with a string navigateTo value")
			invariant(action == nil, ".navigate(): child action can only be provided with a string navigateTo value")

			return NavigationActions.navigate(routeName)
		end,
		setParams = function(params)
			invariant(type(p.key) == "string", ".setParams(): cannot be called by the root navigator")
			return NavigationActions.setParams({ params = params, key = p.key })
		end
	}
end
