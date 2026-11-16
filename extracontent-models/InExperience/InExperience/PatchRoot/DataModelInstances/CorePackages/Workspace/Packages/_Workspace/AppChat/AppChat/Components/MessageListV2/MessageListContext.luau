local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)

return React.createContext(nil)
