local useChatPlatform = require(script.Parent.useChatPlatform)

require(script.Parent.ChatPlatformContext)

local function useChatWindowSettings() -- line: 8
	-- upvalues: useChatPlatform (copy)
	return useChatPlatform().chatWindowSettings
end

return useChatWindowSettings
