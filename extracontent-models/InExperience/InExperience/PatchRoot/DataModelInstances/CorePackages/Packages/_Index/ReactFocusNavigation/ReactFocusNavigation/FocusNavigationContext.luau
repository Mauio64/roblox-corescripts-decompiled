local parent = script.Parent.Parent
require(parent.FocusNavigation)
local React = require(parent.React)

return React.createContext(nil)
