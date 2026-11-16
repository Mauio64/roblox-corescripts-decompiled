local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)

local GetExternalChatMessageSenderStore = require(AppChat.Stores.GetExternalChatMessageSenderStore)
local useExternalChatMessageSender = require(AppChat.Hooks.useExternalChatMessageSender)

local function ExternalChatMessageSenderRegistration(p): nil
	local v = useExternalChatMessageSender(p.isInExperience == true)
	local externalChatMessageSenderStore = GetExternalChatMessageSenderStore()

	React.useEffect(function()
		externalChatMessageSenderStore.setSender(v)
	end, { v, externalChatMessageSenderStore })

	React.useEffect(function()
		return externalChatMessageSenderStore.clearSender
	end, { externalChatMessageSenderStore })

	return nil
end

return ExternalChatMessageSenderRegistration
