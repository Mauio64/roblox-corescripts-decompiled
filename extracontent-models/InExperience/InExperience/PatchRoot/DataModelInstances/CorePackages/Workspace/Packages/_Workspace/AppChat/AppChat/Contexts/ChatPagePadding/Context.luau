local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)

return React.createContext({ top = 0, right = 12, bottom = 0, left = 12 })
