local RoduxPresence = script:FindFirstAncestor("RoduxPresence")
local getDeepValue = require(RoduxPresence.getDeepValue)

return function(p1) -- line: 4
	-- upvalues: getDeepValue (copy)
	local keyPath = p1.keyPath

	return function(p2, p3) -- line: 6
		-- upvalues: getDeepValue (copy), keyPath (copy)
		return getDeepValue(p2, keyPath .. ".byUserId")[p3]
	end
end
