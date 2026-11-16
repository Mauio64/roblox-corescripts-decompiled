local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local React = require(PeopleReactView.Parent.React)

return React.createContext(false)
