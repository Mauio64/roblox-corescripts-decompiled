local Parent = script:FindFirstAncestor("PlayerContextualMenu").Parent
local React = require(Parent.React)
local DefaultHttpRequestInstance = require(script.Parent.DefaultHttpRequestInstance)

return React.createContext(DefaultHttpRequestInstance)
