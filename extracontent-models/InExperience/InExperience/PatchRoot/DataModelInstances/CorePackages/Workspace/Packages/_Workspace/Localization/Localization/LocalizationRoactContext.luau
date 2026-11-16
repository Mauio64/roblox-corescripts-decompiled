local parent = script:FindFirstAncestor("Localization").Parent

local React = require(parent.React)

return React.createContext(nil)
