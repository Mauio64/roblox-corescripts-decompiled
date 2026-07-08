local invariant = require(script.Parent.Parent.utils.invariant)
local isValidScreenComponent = require(script.Parent.Parent.utils.isValidScreenComponent)

return function(p1) -- line: 20
	-- upvalues: invariant (copy), isValidScreenComponent (copy)
	invariant(type(p1) == "table", "routeConfigs must be an array table")

	for v4, v5 in p1 do
		invariant(type(v4) == "number", ("routeConfigs must be an array table (found non-number key %q of type %q)"):format(v4, (type(v4))))

		local v6, v7 = next(v5)

		invariant(next(v5, v6) == nil, ("only one route must be defined in each entry (found multiple at index %d)"):format(v4))

		local v8 = type(v7) == "table" or false
		local v9 = if not v8 then {} else v7
		local v10 = v8 and v7.screen or v7

		invariant(isValidScreenComponent(v10) or type(v9.getScreen) == "function" and isValidScreenComponent(v9.getScreen()), "The component for route '%s' must be a Roact Function/Stateful component or table with 'getScreen'.getScreen function must return Roact Function/Stateful component.", v6)
		invariant(v9.screen == nil or v9.getScreen == nil, "Route '%s' should provide 'screen' or 'getScreen', but not both.", v6)
	end

	invariant(#p1 > 0, "Please specify at least one route when configuring a navigator.")

	return p1
end
