local parent = script:FindFirstAncestor("SplitPane").Parent
local React = require(parent.React)

return React.createContext(nil)
