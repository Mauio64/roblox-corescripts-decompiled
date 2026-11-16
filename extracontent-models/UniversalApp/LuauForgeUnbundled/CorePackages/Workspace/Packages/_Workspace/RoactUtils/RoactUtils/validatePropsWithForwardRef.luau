local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/Roact")

local function validateWithRefForwarding(p2)
	p2.forwardRef = p2[Roact.Ref]
	p2[Roact.Ref] = nil
	return p2
end

return validateWithRefForwarding
