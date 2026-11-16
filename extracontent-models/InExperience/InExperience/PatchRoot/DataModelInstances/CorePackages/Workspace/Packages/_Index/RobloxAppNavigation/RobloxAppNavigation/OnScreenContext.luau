local parent = script:FindFirstAncestor("RobloxAppNavigation").Parent

local React = require(parent.React)

return React.createContext(nil)
