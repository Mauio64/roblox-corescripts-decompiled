local parent = script:FindFirstAncestor("Style").Parent
local React = require(parent.React)
require(parent.UIBlox)

return React.createContext(nil)
