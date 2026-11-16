local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
local React = require(ViewRecyclerReact.Parent.React)

return React.createContext(nil)
