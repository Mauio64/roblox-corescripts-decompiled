local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Enums.InputPlacement)
require(Foundation.Enums.InputSize)

return (React.createContext({ size = nil, placement = nil }))
