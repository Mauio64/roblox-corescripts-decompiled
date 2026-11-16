local parent = script.Parent.Parent
local getDeepValue = require(parent.getDeepValue)

require(parent.RoduxAliasesTypes)

return function(p)
	local keyPath = p.keyPath
	return function(p2, p3)
		return getDeepValue(p2, keyPath .. ".byUserId")[p3]
	end
end
