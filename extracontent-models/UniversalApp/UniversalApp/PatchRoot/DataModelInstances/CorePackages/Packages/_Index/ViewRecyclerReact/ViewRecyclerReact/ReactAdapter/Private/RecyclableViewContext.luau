local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

local React = require(ViewRecyclerReact.Parent.React)
require(ViewRecyclerReact.Parent.Signals)

return React.createContext(false)
