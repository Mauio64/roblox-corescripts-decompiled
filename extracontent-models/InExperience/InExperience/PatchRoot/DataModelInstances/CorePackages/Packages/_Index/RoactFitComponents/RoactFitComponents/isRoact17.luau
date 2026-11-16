local parent = script.Parent.Parent

local Roact = require(parent.Roact)

return function(): boolean
	return Roact.Ref == "ref"
end
