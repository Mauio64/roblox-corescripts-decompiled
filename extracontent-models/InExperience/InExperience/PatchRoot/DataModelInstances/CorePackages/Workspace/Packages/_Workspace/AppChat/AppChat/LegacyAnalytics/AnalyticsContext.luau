local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)

return (Roact.createContext(nil))
