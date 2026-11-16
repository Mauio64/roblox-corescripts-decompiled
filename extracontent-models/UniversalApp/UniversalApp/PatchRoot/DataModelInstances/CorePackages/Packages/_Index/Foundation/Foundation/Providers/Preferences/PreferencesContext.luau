local parent = script.Parent:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

return (React.createContext({}))
