local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local context = React.createContext(nil)
context.displayName = "PluginContext"

return context
