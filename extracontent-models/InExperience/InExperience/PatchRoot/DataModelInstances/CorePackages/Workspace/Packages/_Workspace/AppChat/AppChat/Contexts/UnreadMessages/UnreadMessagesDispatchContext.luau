local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)

return React.createContext(function(_: number) end)
