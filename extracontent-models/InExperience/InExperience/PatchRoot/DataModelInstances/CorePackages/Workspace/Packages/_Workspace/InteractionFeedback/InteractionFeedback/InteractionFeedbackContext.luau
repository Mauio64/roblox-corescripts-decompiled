local parent = script:FindFirstAncestor("InteractionFeedback").Parent
local React = require(parent.React)

return (React.createContext(nil))
