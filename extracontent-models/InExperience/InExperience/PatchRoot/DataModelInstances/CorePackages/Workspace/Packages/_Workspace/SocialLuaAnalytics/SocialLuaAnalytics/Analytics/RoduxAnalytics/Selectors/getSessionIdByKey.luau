local parent = script.Parent.Parent.Parent.Parent
local parent2 = script.Parent.Parent

require(parent2.AnalyticsTypes)
local getDeepValue = require(parent.Utils.getDeepValue)

return function(p)
	local keyPath = p.keyPath
	return function(p2)
		return function(p3)
			return getDeepValue(p2, string.format("%s.bySessionKey.%s", keyPath, p3))
		end
	end
end
