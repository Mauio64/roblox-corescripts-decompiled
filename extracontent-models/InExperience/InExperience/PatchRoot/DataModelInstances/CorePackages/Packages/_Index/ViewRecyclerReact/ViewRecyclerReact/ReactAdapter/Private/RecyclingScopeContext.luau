local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
require(ViewRecyclerReact.Parent.ViewRecycler)
local React = require(ViewRecyclerReact.Parent.React)

require(script.Parent.RecyclingRoot)

return React.createContext(nil)
