local Parent = script:FindFirstAncestor("Style").Parent
local React = require(Parent.React)

require(Parent.Foundation)

return React.createContext(nil)
