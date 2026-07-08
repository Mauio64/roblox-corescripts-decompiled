local NavigationActions = require(script.Parent.Parent.NavigationActions)
local invariant = require(script.Parent.Parent.utils.invariant)

return function(p1) -- line: 4
	-- upvalues: invariant (copy), NavigationActions (copy)
	return {
		goBack = function(p2) -- line: 8
			-- upvalues: p1 (copy), invariant (copy), NavigationActions (copy)
			if p2 == nil and p1.key then
				invariant(type(p1.key) == "string", ".goBack(): key should be a string")
				p2 = p1.key
			end

			return NavigationActions.back({
				key = p2
			})
		end,
		navigate = function(p3, p4, p5) -- line: 19
			-- upvalues: NavigationActions (copy), invariant (copy)
			if type(p3) == "string" then
				return NavigationActions.navigate({
					routeName = p3,
					params = p4,
					action = p5
				})
			end

			invariant(type(p3) == "table", ".navigate(): navigateTo must be a string or table")
			invariant(p4 == nil, ".navigate(): params can only be provided with a string navigateTo value")
			invariant(p5 == nil, ".navigate(): child action can only be provided with a string navigateTo value")

			return NavigationActions.navigate(p3)
		end,
		setParams = function(p6) -- line: 36
			-- upvalues: invariant (copy), p1 (copy), NavigationActions (copy)
			invariant(type(p1.key) == "string", ".setParams(): cannot be called by the root navigator")

			return NavigationActions.setParams({
				params = p6,
				key = p1.key
			})
		end
	}
end
