local ParentParent = script.Parent.Parent
local Number = require(ParentParent.Number)

return function(p1) -- line: 6
	-- upvalues: Number (copy)
	return not not p1 and (p1 ~= 0 and (p1 ~= "" and not Number.isNaN(p1)))
end
