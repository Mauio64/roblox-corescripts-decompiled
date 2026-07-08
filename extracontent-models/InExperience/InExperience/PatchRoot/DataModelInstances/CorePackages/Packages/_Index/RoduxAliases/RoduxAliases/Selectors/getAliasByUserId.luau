local ParentParent = script.Parent.Parent
local getDeepValue = require(ParentParent.getDeepValue)

require(ParentParent.RoduxAliasesTypes)

return function(p1) -- line: 8
	-- upvalues: getDeepValue (copy)
	local keyPath = p1.keyPath

	return function(p2, p3) -- line: 10
		-- upvalues: getDeepValue (copy), keyPath (copy)
		return getDeepValue(p2, keyPath .. ".byUserId")[p3]
	end
end
