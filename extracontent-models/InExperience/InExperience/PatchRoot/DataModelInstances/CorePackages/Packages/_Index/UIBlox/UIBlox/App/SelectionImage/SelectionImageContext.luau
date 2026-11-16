local parent = script.Parent.Parent.Parent.Parent
local Roact = require(parent.Roact)

return (Roact.createContext(function(): nil
	return nil
end))
