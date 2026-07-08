local NavigationSymbol = require(script.Parent.NavigationSymbol)
local v2 = NavigationSymbol("NONE")
local v3 = NavigationSymbol("INITIAL_ROUTE")
local v4 = NavigationSymbol("ORDER")
local v5 = NavigationSymbol("HISTORY")
local t1 = {
	None = v2,
	InitialRoute = v3,
	Order = v4,
	History = v5
}

setmetatable(t1, {
	__index = function(_, p2) -- line: 24
		error(("%q is not a valid member of BackBehavior"):format((tostring(p2))), 2)
	end
})

return t1
