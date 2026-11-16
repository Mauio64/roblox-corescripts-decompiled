local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local GetConversationMessageListStore = require(parent.AppChat.GetConversationMessageListStore)
local GetConversationStore = require(parent.AppChat.GetConversationStore)

local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local useMessagePool = ChatUIPrimitives.useMessagePool
local useMessageDisplayStore = require(script.Parent.Parent.Message.MessageDisplayStore.useMessageDisplayStore)
local FriendsChatTextMessage = require(script.Parent.Parent.Message.FriendsChatTextMessage)
local FriendsChatOsaSystemMessage = require(script.Parent.FriendsChatOsaSystemMessage)
local getOsaParticipantUserId = require(script.Parent.getOsaParticipantUserId)
local useLocalize = require(script.Parent.Parent.Utils.useLocalize)

local element = React.createElement("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder })

local function useConversationMessagePool(data)
	local conversationId = data.conversationId
	local shouldReadMessages = data.shouldReadMessages

	local v = React.useMemo(function()
		if shouldReadMessages then
			return function(p)
				return GetConversationMessageListStore(p).getOrderedIds(conversationId, p)
			end
		end

		return function()
			return {}
		end
	end, { conversationId, shouldReadMessages })

	local localize = useLocalize()

	local v2 = useMessageDisplayStore(v, conversationId)

	local createSlotElement = React.useCallback(function(p)
		return React.createElement(FriendsChatTextMessage, {
			getDisplayId = p.getMessageId,
			getDisplayFromId = v2.getDisplayFromId,
			getMessageIdFromDisplayId = v2.getMessageIdFromDisplayId,
			getLayoutOrder = p.getLayoutOrder,
			chatWindowSettings = data.chatWindowSettings,
			textTransparency = data.textTransparency,
			isSpatialUIEnabled = data.isSpatialUIEnabled,
			localize = localize
		})
	end, { v2, data.chatWindowSettings, data.textTransparency, data.isSpatialUIEnabled, localize })

	local v3 = useMessagePool({
		messageIdsSignal = v2.getDisplayIds,
		createSlotElement = createSlotElement,
		maxSlots = 50
	})

	return (React.useMemo(function()
		return Signals.createComputed(function(p)
			local clone = table.clone(v3(p))
			clone["$layout"] = element
			local osaParticipantUserId = getOsaParticipantUserId((GetConversationStore(p).getConversation(conversationId, p)))

			if osaParticipantUserId then
				clone[`osa-system-message-{conversationId}`] = React.createElement(FriendsChatOsaSystemMessage, {
					conversationId = conversationId,
					userId = osaParticipantUserId,
					chatWindowSettings = data.chatWindowSettings,
					textTransparency = data.textTransparency,
					isSpatialUIEnabled = data.isSpatialUIEnabled,
					localize = localize
				})
			end

			return clone
		end)
	end, {
		v3,
		conversationId,
		data.chatWindowSettings,
		data.textTransparency,
		data.isSpatialUIEnabled,
		localize
	}))
end

return useConversationMessagePool
