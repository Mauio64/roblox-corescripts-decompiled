local Parent = script:FindFirstAncestor("RoactUtils").Parent
local Roact = require(Parent.Roact)

local function validateWithRefForwarding(p1) -- line: 6
	-- upvalues: Roact (copy)
	p1.forwardRef = p1[Roact.Ref]
	p1[Roact.Ref] = nil

	return p1
end

return validateWithRefForwarding
