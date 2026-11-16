local parent = script.Parent
local parent2 = script:FindFirstAncestor("Foundation").Parent

require(parent.Tokens)

local React = require(parent2.React)

return (React.createContext({}))
