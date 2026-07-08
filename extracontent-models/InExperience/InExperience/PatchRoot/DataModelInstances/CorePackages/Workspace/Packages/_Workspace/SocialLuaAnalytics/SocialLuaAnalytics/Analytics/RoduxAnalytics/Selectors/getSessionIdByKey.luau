local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParent2 = script.Parent.Parent

require(ParentParent2.AnalyticsTypes)

local getDeepValue = require(ParentParent.Utils.getDeepValue)

return function(p1) -- line: 7
	-- upvalues: getDeepValue (copy)
	local keyPath = p1.keyPath

	return function(p2) -- line: 9
		-- upvalues: getDeepValue (copy), keyPath (copy)
		return function(p3) -- line: 10
			-- upvalues: getDeepValue (copy), p2 (copy), keyPath (copy)
			return getDeepValue(p2, string.format("%s.bySessionKey.%s", keyPath, p3))
		end
	end
end
