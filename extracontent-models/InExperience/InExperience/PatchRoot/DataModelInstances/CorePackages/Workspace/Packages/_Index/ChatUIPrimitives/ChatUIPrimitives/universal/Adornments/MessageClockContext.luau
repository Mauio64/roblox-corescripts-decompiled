local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
require(parent.Signals)

return (React.createContext(nil))
