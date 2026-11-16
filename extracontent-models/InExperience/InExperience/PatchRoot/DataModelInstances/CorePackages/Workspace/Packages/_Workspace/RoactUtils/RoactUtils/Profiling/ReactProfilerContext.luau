local parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(parent.React)

require(script.Parent.types)

return React.createContext(nil)
