local parent = script.Parent
require(parent.RoduxAliasesTypes)

return function(p)
	local getAliasByUserId = require(script.getAliasByUserId)
	return { getAliasByUserId = getAliasByUserId(p) }
end
