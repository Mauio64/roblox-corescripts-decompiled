local parent = script:FindFirstAncestor("ExpChat").Parent
local Roact = require(parent.Roact)

return Roact.createContext({ isSpatialUIEnabled = false })
