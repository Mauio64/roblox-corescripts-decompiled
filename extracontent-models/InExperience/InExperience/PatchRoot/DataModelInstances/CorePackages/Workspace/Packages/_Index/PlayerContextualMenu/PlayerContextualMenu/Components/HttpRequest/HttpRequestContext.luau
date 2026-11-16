local parent = script:FindFirstAncestor("PlayerContextualMenu").Parent
local React = require(parent.React)

local DefaultHttpRequestInstance = require(script.Parent.DefaultHttpRequestInstance)

return React.createContext(DefaultHttpRequestInstance)
