local parent = script.Parent
local getDeepValue = require(parent.getDeepValue)
local EnumNetworkStatus = require(parent.EnumNetworkStatus)

return function(p)
	local keyPath = p.keyPath

	return function(p2, value)
		assert(typeof(p2) == "table")
		assert(typeof(value) == "string")
		assert(#value > 0)
		local deepValue = getDeepValue(p2, keyPath)
		assert(
			deepValue,
			string.format("Reducer not found for keyPath: %s. Did you forget to call `installReducer`?", keyPath)
		)

		return deepValue[value] or EnumNetworkStatus.NotStarted
	end
end
