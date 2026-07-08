local scriptParent = script.Parent

require(scriptParent.RoduxAliasesTypes)

return function(p1) -- line: 6
	return {
		getAliasByUserId = require(script.getAliasByUserId)(p1)
	}
end
