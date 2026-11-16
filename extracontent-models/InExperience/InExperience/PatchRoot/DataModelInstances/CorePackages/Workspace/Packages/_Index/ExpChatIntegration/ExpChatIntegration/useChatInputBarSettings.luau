local parent = script:FindFirstAncestor("ExpChatIntegration").Parent

local SignalsReact = require(parent.SignalsReact)

local useChatPlatform = require(script.Parent.useChatPlatform)

local function useChatInputBarSettings()
	local getChatInputBarSettings = useChatPlatform().getChatInputBarSettings
	return SignalsReact.useSignalState(getChatInputBarSettings)
end

return useChatInputBarSettings
