local parent = script:FindFirstAncestor("Responsive").Parent
local React = require(parent.React)

return React.createContext(nil)
