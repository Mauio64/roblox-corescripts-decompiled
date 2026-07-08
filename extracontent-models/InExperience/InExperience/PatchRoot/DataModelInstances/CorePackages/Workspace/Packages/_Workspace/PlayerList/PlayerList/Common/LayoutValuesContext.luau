local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)

require(script.Parent.CreateLayoutValues)

return (React.createContext({}))
