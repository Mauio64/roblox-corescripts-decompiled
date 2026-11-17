local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local context = React.createContext({ id = nil, ready = true })
context.displayName = "PluginPopoverParentContext"

return context
