local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

require(script.Parent.createChatCardEmphasisStore)

return React.createContext(nil)
