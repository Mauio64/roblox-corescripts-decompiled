local Parent = script:FindFirstAncestor("ExpChatIntegration").Parent
local React = require(Parent.React)

require(script.Parent.ChatPlatformTypes)

local createDefaultChatPlatformValue = require(script.Parent.createDefaultChatPlatformValue)

return React.createContext(createDefaultChatPlatformValue())
