local parent = script.Parent.Parent.Parent

local React = require(parent.React)
require(script.Parent.CreateLayoutValues)

return (React.createContext({}))
