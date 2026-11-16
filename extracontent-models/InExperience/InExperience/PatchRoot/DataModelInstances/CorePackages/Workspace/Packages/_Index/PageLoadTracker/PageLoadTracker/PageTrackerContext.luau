local parent = script:FindFirstAncestor("PageLoadTracker").Parent
local React = require(parent.React)

require(script.Parent.createPageTracker)

return React.createContext(nil)
