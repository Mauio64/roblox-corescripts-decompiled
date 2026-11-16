local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

require(script.Parent.Types)

local context = React.createContext(nil)
context.displayName = "WidgetsContext"

return context
