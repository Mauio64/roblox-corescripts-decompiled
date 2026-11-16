local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
require(parent.ChatUIPrimitives.MessageList)
local ExpChatShared = require(parent.ExpChatShared)
local GetConversationStore = require(parent.AppChat.GetConversationStore)
local GetConversationMessageListStore = require(parent.AppChat.GetConversationMessageListStore)
local fetchOlderMessages = require(parent.AppChat.fetchOlderMessages)
local useChatPlatform = require(parent.ExpChatIntegration.useChatPlatform)

local FFlagFriendsChatPaginateOlderMessages = require(FriendsChat.Flags.FFlagFriendsChatPaginateOlderMessages)
local FIntFriendsChatBubbleMaxMessages = require(FriendsChat.Flags.FIntFriendsChatBubbleMaxMessages)

local useConversationEnvelopes = require(script.Parent.Parent.Message.BubbleEnvelopes.useConversationEnvelopes)
local getLocalUserId = require(script.Parent.Parent.Utils.getLocalUserId)
local useChatWindowReport = require(script.Parent.Parent.Utils.useChatWindowReport)
local useLocalize = require(script.Parent.Parent.Utils.useLocalize)
require(script.Parent.FriendsChatBubbleMessageListView)
local FriendsChatOsaSystemMessage = require(script.Parent.FriendsChatOsaSystemMessage)
local getOsaParticipantUserId = require(script.Parent.getOsaParticipantUserId)

local binding = React.createBinding(0)

local v = ExpChatShared.Logger:new(script.Name)

local function isSameOsaState(data, data2): boolean
	return data.hasRecord == data2.hasRecord
		and data.osaUserId == data2.osaUserId
		and data.hasOlderPage == data2.hasOlderPage
end

local function isBelowHideThreshold(p: number): boolean
	return p < ExpChatShared.Config.ChatWindowMessageHideRootFadeThreshold
end

local function getTopFadeSequence(list)
	local item = list[1]
	local item2 = list[2]

	if item2 <= 0 or item <= item2 then
		return NumberSequence.new(0)
	end

	return NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(item2 / item, 0),
		NumberSequenceKeypoint.new(1, 0)
	})
end

local function useFriendsChatBubbleMessageListViewModel(data)
	local localize = useLocalize()
	local v2, v3 = React.useBinding(0)

	local onMaskAbsoluteSizeChanged = React.useCallback(function(p)
		v3(p.AbsoluteSize.Y)
	end, {})

	local ref = React.useRef(nil)
	React.useEffect(function()
		local current = ref.current

		if current then
			onMaskAbsoluteSizeChanged(current)
		end
	end, { onMaskAbsoluteSizeChanged })

	local v4, v5 = React.useBinding(0)
	local onCanvasPositionChanged = React.useCallback(function(vector2: Vector2)
		local v6 = math.clamp(vector2.Y, 0, 16)

		if v6 ~= v4:getValue() then
			v5(v6)
		end
	end, { v4, v5 })

	local topFade = React.useMemo(function()
		return React.joinBindings({ v2, v4 }):map(getTopFadeSequence)
	end, { v2, v4 })

	local conversationId = data.conversationId
	local v6 = useConversationEnvelopes({
		conversationId = conversationId,
		shouldReadMessages = data.hasConversationId
	})
	local v7

	if FFlagFriendsChatPaginateOlderMessages and FIntFriendsChatBubbleMaxMessages == 0 and data.isRealConversation then
		v7 = conversationId
	else
		v7 = nil
	end

	local v8 = v7 ~= nil
	local v9 = React.useMemo(function()
		return Signals.createComputed(function(p)
			local conversation = GetConversationStore(p).getConversation(conversationId, p)
			local v9

			if v8 then
				v9 = GetConversationMessageListStore(p).getMetadata(conversationId, p)
			end

			return {
				hasRecord = conversation ~= nil,
				osaUserId = getOsaParticipantUserId(conversation),
				hasOlderPage = v9 ~= nil and v9.nextPageCursor ~= nil and not v9.fetchedOldest
			}
		end, isSameOsaState)
	end, { conversationId, v8 })
	local v10 = SignalsReact.useSignalState(v9)
	local osaUserId = v10.osaUserId

	local initialScrollPosition = (osaUserId == nil or not data.shouldOpenToOsaSystemMessage) and "end" or "start"

	local isReady = (not data.isRealConversation or v10.hasRecord)
		and (initialScrollPosition == "end" or data.hasLoadedNewestPage)

	local v11 = data.shouldOpenToOsaSystemMessage

	if FFlagFriendsChatPaginateOlderMessages then
		local ref2 = React.useRef(nil)

		if isReady and (ref2.current == nil or ref2.current.conversationId ~= conversationId) then
			ref2.current = {
				conversationId = conversationId,
				atDisclosure = data.shouldOpenToOsaSystemMessage
			}
		end

		local current = ref2.current

		if current ~= nil and current.conversationId == conversationId then
			v11 = current.atDisclosure
		end
	end

	if v8 and (not data.hasLoadedNewestPage or not v11 and v10.hasOlderPage) then
		osaUserId = nil
	end

	local chatWindowSettings = data.chatWindowSettings
	local isSpatialUIEnabled = data.isSpatialUIEnabled

	local header = React.useMemo(function()
		if osaUserId == nil then
			return nil
		end

		return React.createElement(FriendsChatOsaSystemMessage, {
			conversationId = conversationId,
			userId = osaUserId,
			chatWindowSettings = chatWindowSettings,
			isSpatialUIEnabled = isSpatialUIEnabled,
			localize = localize
		})
	end, { conversationId, osaUserId, chatWindowSettings, isSpatialUIEnabled, localize })

	local getTransparencyStore = useChatPlatform().getTransparencyStore
	local onUserScrollInput = React.useCallback(function()
		getTransparencyStore(false).resetAllTransparency()
	end, { getTransparencyStore })

	local localUserId = getLocalUserId()
	local messageListProps = React.useMemo(function()
		local fn

		if v7 ~= nil then
			local v12 = v7
			fn = function()
				fetchOlderMessages(v12):catch(function(p)
					v:warning(`Failed to fetch older messages for {v12}: {tostring(p)}`)
				end)
			end
		end

		local v12 = {
			displayMode = "bubble",
			getMessageEnvelopes = v6.getEnvelopes,
			maxGroupGapMs = 300000,
			observingUserId = 0,
			header = 0,
			initialScrollPosition = 0,
			onUserScrollInput = 0,
			onCanvasPositionChanged = 0,
			onNearOldestMessage = 0
		}
		local observingUserId

		if localUserId then
			observingUserId = tostring(localUserId)
		end

		v12.observingUserId = observingUserId
		v12.header = header
		v12.initialScrollPosition = initialScrollPosition
		v12.onUserScrollInput = onUserScrollInput
		v12.onCanvasPositionChanged = onCanvasPositionChanged
		v12.onNearOldestMessage = fn
		return v12
	end, {
		v6,
		localUserId,
		header,
		initialScrollPosition,
		onUserScrollInput,
		onCanvasPositionChanged,
		v7
	})

	local textTransparency = data.textTransparency or binding
	local messagesVisible = React.useMemo(function()
		return textTransparency:map(isBelowHideThreshold)
	end, { textTransparency })

	local onSlotAbsoluteSizeChanged = useChatWindowReport(data.onAbsoluteSizeChanged)
	local onSlotAbsolutePositionChanged = useChatWindowReport(data.onAbsolutePositionChanged)

	return {
		layoutOrder = data.layoutOrder,
		conversationId = conversationId,
		isReady = isReady,
		topInset = data.topInset,
		textTransparency = textTransparency,
		messagesVisible = messagesVisible,
		topFade = topFade,
		maskRef = ref,
		onMaskAbsoluteSizeChanged = onMaskAbsoluteSizeChanged,
		onSlotAbsoluteSizeChanged = onSlotAbsoluteSizeChanged,
		onSlotAbsolutePositionChanged = onSlotAbsolutePositionChanged,
		onHovered = data.onHovered,
		onUnhovered = data.onUnhovered,
		messageListProps = messageListProps
	}
end

return useFriendsChatBubbleMessageListViewModel
