local parent = script:FindFirstAncestor("Style").Parent
local React = require(parent.React)
require(parent.Foundation)

return React.createContext({})
