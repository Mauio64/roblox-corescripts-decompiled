local useChatPlatform = require(script.Parent.useChatPlatform)
require(script.Parent.ChatPlatformContext)

local function useChatWindowSettings()
	return useChatPlatform().chatWindowSettings
end

return useChatWindowSettings
