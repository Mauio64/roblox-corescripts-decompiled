local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local MessageContextMenu = require(script.Parent.MessageContextMenu)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)

local v = { messageId = "", conversationId = "", inputBoxRef = nil }

function MessageContextMenuContainer(p)
	local union = Cryo.Dictionary.union(v, p)

	local v2 = useGetConversationFromId(union.conversationId)
	local message

	if v2 and v2.messages then
		message = v2.messages:Get(union.messageId)
	end

	local v3 = useLocalUserId()

	if not message then
		return nil
	end

	local userOwnsMessage = message.senderTargetId == v3

	return React.createElement(
		MessageContextMenu,
		Cryo.Dictionary.union(union, { message = message, userOwnsMessage = userOwnsMessage })
	)
end

return React.memo(MessageContextMenuContainer)
