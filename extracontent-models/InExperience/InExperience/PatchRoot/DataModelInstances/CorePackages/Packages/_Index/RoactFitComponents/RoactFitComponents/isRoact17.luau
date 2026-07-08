local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)

return function() -- line: 7
	-- upvalues: Roact (copy)
	return Roact.Ref == "ref"
end
