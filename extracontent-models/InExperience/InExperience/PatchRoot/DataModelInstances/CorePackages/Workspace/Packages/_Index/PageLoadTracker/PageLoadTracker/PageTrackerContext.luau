local Parent = script:FindFirstAncestor("PageLoadTracker").Parent
local React = require(Parent.React)

require(script.Parent.createPageTracker)

return React.createContext(nil)
