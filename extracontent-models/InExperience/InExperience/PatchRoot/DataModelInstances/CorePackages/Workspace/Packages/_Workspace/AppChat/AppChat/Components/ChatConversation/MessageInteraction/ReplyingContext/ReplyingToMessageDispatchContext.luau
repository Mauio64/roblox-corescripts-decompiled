local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)

require(script.Parent.ReplyingToMessageContext)

return React.createContext(function(_) end)
