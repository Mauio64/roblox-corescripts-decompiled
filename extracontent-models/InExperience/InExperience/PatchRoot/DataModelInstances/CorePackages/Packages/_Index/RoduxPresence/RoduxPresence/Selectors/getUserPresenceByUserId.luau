local RoduxPresence = script:FindFirstAncestor("RoduxPresence")
local getDeepValue = require(RoduxPresence.getDeepValue)

return function(p)
	local keyPath = p.keyPath
	return function(p2, p3)
		return getDeepValue(p2, keyPath .. ".byUserId")[p3]
	end
end
