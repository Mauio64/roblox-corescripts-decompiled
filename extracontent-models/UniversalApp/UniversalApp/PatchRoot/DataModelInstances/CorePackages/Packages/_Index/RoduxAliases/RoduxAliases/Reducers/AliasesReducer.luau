local parent = script.Parent.Parent
local byUserId = require(parent.Reducers.Aliases.byUserId)

require(parent.RoduxAliasesTypes)

local v = {}

return function(p)
	return function(p2, p3)
		return {
			byUserId = byUserId(p)((p2 or v).byUserId, p3)
		}
	end
end
