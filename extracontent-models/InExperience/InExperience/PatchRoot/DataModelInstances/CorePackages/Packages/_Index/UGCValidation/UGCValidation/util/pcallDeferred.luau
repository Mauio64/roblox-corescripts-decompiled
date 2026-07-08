local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local tryYield = require(ParentParent.util.tryYield)

return function(p1: ((...any) -> ...any), p2) -- line: 11
	-- upvalues: tryYield (copy)
	tryYield(p2)

	return pcall(p1)
end
