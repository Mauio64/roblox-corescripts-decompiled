local NavigationSymbol = require(script.Parent.NavigationSymbol)

local BackBehavior = {
	None = NavigationSymbol("NONE"),
	InitialRoute = NavigationSymbol("INITIAL_ROUTE"),
	Order = NavigationSymbol("ORDER"),
	History = NavigationSymbol("HISTORY")
}

setmetatable(BackBehavior, {
	__index = function(_, p)
		error(("%q is not a valid member of BackBehavior"):format((tostring(p))), 2)
	end
})

return BackBehavior
