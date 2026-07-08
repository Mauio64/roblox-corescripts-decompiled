local ParentParent = script.Parent.Parent.Parent

require(ParentParent.ES7Types)

local indexOf = require(script.Parent.indexOf)

return function(p1, p2, n1: number?) -- line: 22
	-- upvalues: indexOf (copy)
	return indexOf(p1, p2, n1) ~= -1
end
