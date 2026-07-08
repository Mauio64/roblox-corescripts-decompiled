local ParentParent = script.Parent.Parent
local byUserId = require(ParentParent.Reducers.Aliases.byUserId)

require(ParentParent.RoduxAliasesTypes)

local t1 = {}

return function(p1) -- line: 10
	-- upvalues: t1 (copy), byUserId (copy)
	return function(p2, p3) -- line: 11
		-- upvalues: t1 (copy), byUserId (copy), p1 (copy)
		local v7 = p2 or t1

		return {
			byUserId = byUserId(p1)(v7.byUserId, p3)
		}
	end
end
