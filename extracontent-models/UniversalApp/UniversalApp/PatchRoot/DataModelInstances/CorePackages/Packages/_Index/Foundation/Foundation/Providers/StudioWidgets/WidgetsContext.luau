local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)

require(script.Parent.Types)

local v3 = React.createContext(nil)

v3.displayName = "WidgetsContext"

return v3
