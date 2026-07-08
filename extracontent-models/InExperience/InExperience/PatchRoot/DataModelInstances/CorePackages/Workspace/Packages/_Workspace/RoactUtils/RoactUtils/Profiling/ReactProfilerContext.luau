local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)

require(script.Parent.types)

return React.createContext(nil)
