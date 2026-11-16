local parent = script:FindFirstAncestor("ExpChatIntegration").Parent

local React = require(parent.React)

local ChatPlatformContext = require(script.Parent.ChatPlatformContext)

local function useChatPlatform()
	return React.useContext(ChatPlatformContext)
end

return useChatPlatform
