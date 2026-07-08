local Parent = script:FindFirstAncestor("ExpChatIntegration").Parent
local SignalsReact = require(Parent.SignalsReact)
local useChatPlatform = require(script.Parent.useChatPlatform)

local function useChatInputBarSettings() -- line: 8
	-- upvalues: useChatPlatform (copy), SignalsReact (copy)
	local getChatInputBarSettings = useChatPlatform().getChatInputBarSettings

	return SignalsReact.useSignalState(getChatInputBarSettings)
end

return useChatInputBarSettings
