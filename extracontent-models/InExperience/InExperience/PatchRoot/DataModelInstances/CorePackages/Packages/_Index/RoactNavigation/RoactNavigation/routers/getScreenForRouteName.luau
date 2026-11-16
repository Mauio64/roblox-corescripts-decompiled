local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local invariant = require(parent.utils.invariant)
local isValidScreenComponent = require(parent.utils.isValidScreenComponent)

return function(p, p2)
	local v = p[p2]

	if v == nil then
		local mapped = Array.map(Object.keys(p), function(p3)
			return ("'%s'"):format(p3)
		end)

		local formatted = ("There is no route defined for key %s.\nMust be one of: %s"):format(
			p2,
			table.concat(mapped, ",")
		)

		error(formatted, 2)
	end

	if type(v) == "table" then
		if v.screen ~= nil then
			invariant(isValidScreenComponent(v.screen), "screen for key '%s' must be a valid Roact component.", p2)

			return v.screen
		end

		if type(v.getScreen) == "function" then
			local screen = v.getScreen()
			invariant(
				isValidScreenComponent(screen),
				"The getScreen defined for route '%s' didn't return a valid screen or navigator.\n\nPlease pass it like this:\n%s = {\n    getScreen: function() return MyScreen end\n}",
				p2,
				p2
			)

			return screen
		end
	end

	invariant(
		isValidScreenComponent(v),
		"Value for key '%s' must be a route config table or a valid Roact component.",
		p2
	)

	return v
end
