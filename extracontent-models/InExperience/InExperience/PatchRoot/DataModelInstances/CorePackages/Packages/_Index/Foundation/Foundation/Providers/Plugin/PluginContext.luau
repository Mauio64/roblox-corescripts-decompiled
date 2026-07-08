local Parent = script:FindFirstAncestor("Foundation").Parent
local v2 = require(Parent.React).createContext(nil)

v2.displayName = "PluginContext"

return v2
