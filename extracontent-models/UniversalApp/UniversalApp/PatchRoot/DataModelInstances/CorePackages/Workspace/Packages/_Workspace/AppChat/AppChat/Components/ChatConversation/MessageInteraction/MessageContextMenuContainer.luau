local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local MessageContextMenu = require(script.Parent.MessageContextMenu)
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local t1 = {
	messageId = "",
	conversationId = "",
	inputBoxRef = nil
}

function MessageContextMenuContainer(t2: {[any]: any}) -- line: 32
	-- upvalues: Cryo (copy), t1 (copy), useGetConversationFromId (copy), useLocalUserId (copy), React (copy), MessageContextMenu (copy)
	local v10 = Cryo.Dictionary.union(t1, t2)
	local v11 = useGetConversationFromId(v10.conversationId)
	local v12 = nil

	if v11 and v11.messages then
		v12 = v11.messages:Get(v10.messageId)
	end

	local v13 = useLocalUserId()

	if v12 then
		local v14 = v13 == v12.senderTargetId

		return React.createElement(MessageContextMenu, Cryo.Dictionary.union(v10, {
			message = v12,
			userOwnsMessage = v14
		}))
	end

	return nil
end

return React.memo(MessageContextMenuContainer)
