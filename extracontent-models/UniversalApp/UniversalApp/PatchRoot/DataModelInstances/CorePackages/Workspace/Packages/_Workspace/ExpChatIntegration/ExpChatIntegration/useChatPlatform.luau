local Parent = script:FindFirstAncestor("ExpChatIntegration").Parent
local React = require(Parent.React)
local ChatPlatformContext = require(script.Parent.ChatPlatformContext)

local function useChatPlatform() -- line: 14
	-- upvalues: React (copy), ChatPlatformContext (copy)
	return React.useContext(ChatPlatformContext)
end

return useChatPlatform
