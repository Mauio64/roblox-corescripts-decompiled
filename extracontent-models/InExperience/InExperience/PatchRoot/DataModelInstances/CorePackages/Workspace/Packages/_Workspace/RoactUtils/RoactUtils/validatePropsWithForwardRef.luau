local parent = script:FindFirstAncestor("RoactUtils").Parent

local Roact = require(parent.Roact)

local function validateWithRefForwarding(p)
	p.forwardRef = p[Roact.Ref]
	p[Roact.Ref] = nil
	return p
end

return validateWithRefForwarding
