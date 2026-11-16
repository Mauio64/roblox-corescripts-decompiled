local parent = script:FindFirstAncestor("ExpChatIntegration").Parent

local React = require(parent.React)

require(script.Parent.ChatPlatformTypes)
local createDefaultChatPlatformValue = require(script.Parent.createDefaultChatPlatformValue)

return React.createContext(createDefaultChatPlatformValue())
