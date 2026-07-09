local scriptParent = script.Parent
local createStyleProvider = require(scriptParent.createStyleProvider)

return function(p1) -- line: 4
	-- upvalues: createStyleProvider (copy)
	return createStyleProvider({
		TestElement = p1
	})
end
