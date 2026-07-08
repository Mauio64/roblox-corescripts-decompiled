local scriptParent = script.Parent
local getDeepValue = require(scriptParent.getDeepValue)
local EnumNetworkStatus = require(scriptParent.EnumNetworkStatus)

return function(p1) -- line: 5
	-- upvalues: getDeepValue (copy), EnumNetworkStatus (copy)
	local keyPath = p1.keyPath

	return function(p2, p3) -- line: 8
		-- upvalues: getDeepValue (copy), keyPath (copy), EnumNetworkStatus (copy)
		assert(typeof(p2) == "table")
		assert(typeof(p3) == "string")
		assert(#p3 > 0)

		local v8 = getDeepValue(p2, keyPath)

		assert(v8, string.format("Reducer not found for keyPath: %s. Did you forget to call `installReducer`?", keyPath))

		return v8[p3] or EnumNetworkStatus.NotStarted
	end
end
