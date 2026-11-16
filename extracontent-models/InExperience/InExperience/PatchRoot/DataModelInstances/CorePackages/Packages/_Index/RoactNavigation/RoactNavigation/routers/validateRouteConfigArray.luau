local invariant = require(script.Parent.Parent.utils.invariant)
local isValidScreenComponent = require(script.Parent.Parent.utils.isValidScreenComponent)

return function(list)
	invariant(type(list) == "table", "routeConfigs must be an array table")

	for k, item in list do
		invariant(
			type(k) == "number",
			("routeConfigs must be an array table (found non-number key %q of type %q)"):format(k, (type(k)))
		)

		local v, v2 = next(item)
		invariant(
			next(item, v) == nil,
			("only one route must be defined in each entry (found multiple at index %d)"):format(k)
		)

		local v3 = type(v2) == "table"
		local v4 = not v3 and {} or v2
		v2 = v3 and v2.screen or v2

		local v5 = isValidScreenComponent(v2)

		if not v5 then
			if type(v4.getScreen) == "function" then
				v5 = isValidScreenComponent(v4.getScreen())
			else
				v5 = false
			end
		end

		invariant(
			v5,
			"The component for route '%s' must be a Roact Function/Stateful component or table with 'getScreen'.getScreen function must return Roact Function/Stateful component.",
			v
		)

		invariant(
			v4.screen == nil or v4.getScreen == nil,
			"Route '%s' should provide 'screen' or 'getScreen', but not both.",
			v
		)
	end

	invariant(#list > 0, "Please specify at least one route when configuring a navigator.")

	return list
end
