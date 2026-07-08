local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local invariant = require(ParentParent.utils.invariant)
local isValidScreenComponent = require(ParentParent.utils.isValidScreenComponent)

return function(p1, p2) -- line: 12
	-- upvalues: Array (copy), Object (copy), invariant (copy), isValidScreenComponent (copy)
	local v10 = p1[p2]

	if v10 == nil then
		local v11 = Array.map(Object.keys(p1), function(p3) -- line: 16
			return ("'%s'"):format(p3)
		end)
		local v12 = ("There is no route defined for key %s.\nMust be one of: %s"):format(p2, table.concat(v11, ","))

		error(v12, 2)
	end

	if type(v10) == "table" then
		if v10.screen ~= nil then
			invariant(isValidScreenComponent(v10.screen), "screen for key '%s' must be a valid Roact component.", p2)

			return v10.screen
		end

		if type(v10.getScreen) == "function" then
			local v13 = v10.getScreen()

			invariant(isValidScreenComponent(v13), "The getScreen defined for route '%s' didn't return a valid screen or navigator.\n\nPlease pass it like this:\n%s = {\n    getScreen: function() return MyScreen end\n}", p2, p2)

			return v13
		end
	end

	invariant(isValidScreenComponent(v10), "Value for key '%s' must be a route config table or a valid Roact component.", p2)

	return v10
end
