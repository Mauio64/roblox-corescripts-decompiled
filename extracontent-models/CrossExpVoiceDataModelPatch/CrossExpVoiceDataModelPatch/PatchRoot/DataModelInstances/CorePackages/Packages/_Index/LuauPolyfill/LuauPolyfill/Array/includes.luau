local ParentParent = script.Parent.Parent

require(ParentParent.types)

local indexOf = require(script.Parent.indexOf)

return function(p1, p2, n1: number?) -- line: 7
	-- upvalues: indexOf (copy)
	return indexOf(p1, p2, n1) ~= -1
end
