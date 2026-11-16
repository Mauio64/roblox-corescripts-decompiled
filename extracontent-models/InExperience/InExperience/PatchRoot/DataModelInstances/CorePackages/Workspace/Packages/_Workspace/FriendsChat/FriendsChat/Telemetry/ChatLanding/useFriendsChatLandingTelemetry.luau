local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local React = require(parent.React)

local ChatLandingTelemetryEvents = require(parent.AppChat.ChatLandingTelemetryEvents)
local ChatLandingTelemetryLayer = require(parent.AppChat.ChatLandingTelemetryLayer)
local ChatLandingTelemetryState = require(parent.AppChat.ChatLandingTelemetryState)
require(parent.AppChat.GetConversationListStore)
local GetFriendsChatSettingsStore = require(parent.AppChat.GetFriendsChatSettingsStore)
local useTelemetry = require(parent.AppChat.useTelemetry)

local FFlagFriendsChatLandingTelemetryFields = require(FriendsChat.Flags.FFlagFriendsChatLandingTelemetryFields)

local getChatLandingConversationInfo = require(script.Parent.getChatLandingConversationInfo)
local getChatLandingSharedCounts = require(script.Parent.getChatLandingSharedCounts)

local function getIsChatEnabled() -- 1 equivalent call inferred from this helper
	return GetFriendsChatSettingsStore(false).getChatEnabled(false)
end

local function useFriendsChatLandingTelemetry(data)
	local emit = useTelemetry(ChatLandingTelemetryLayer.Context).emit
	local v = ChatLandingTelemetryState.useSetState()

	local ref = React.useRef(data.displayedConversations)
	ref.current = data.displayedConversations
	local ref2 = React.useRef(data.isFiltered)
	ref2.current = data.isFiltered
	local ref3 = React.useRef(emit)
	ref3.current = emit

	local v2 = React.useMemo(function()
		return getChatLandingSharedCounts(data.conversations)
	end, { data.conversations })

	React.useEffect(function()
		v(function(p)
			local clone = table.clone(p)
			clone.chatLandingListCount = v2.chatLandingListCount
			clone.pendingConversationCount = v2.pendingConversationCount
			clone.unfilteredConversationCount = v2.unfilteredConversationCount
			return clone
		end)
	end, { v2, v })

	React.useEffect(function()
		ref3.current(ChatLandingTelemetryEvents.ScreenRendered, {
			isChatEnabled = getIsChatEnabled() -- inferred equivalent call
		})
	end, {})

	local emptyStateType = data.emptyStateType
	React.useEffect(function()
		if FFlagFriendsChatLandingTelemetryFields and emptyStateType ~= nil then
			ref3.current(ChatLandingTelemetryEvents.ChatEmptyStateScreenRendered, {
				emptyStateType = emptyStateType
			})
		end
	end, { emptyStateType })

	return {
		fireSearchActivatedEvent = React.useCallback(function()
			ref3.current(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
		end, {}),
		fireConversationClickedEvent = React.useCallback(function(p, _, osaImpressionId: string?)
			if p == nil or p.id == nil then
				return
			end

			local chatLandingConversationInfo = getChatLandingConversationInfo(
				p,
				ref.current or {},
				ref2.current == true
			)
			local clone = table.clone(chatLandingConversationInfo)
			clone.osaImpressionId = osaImpressionId

			ref3.current(ChatLandingTelemetryEvents.ConversationClicked, clone)
			ref3.current(ChatLandingTelemetryEvents.ConversationClickedIndexStat, {
				statValue = chatLandingConversationInfo.selectedIndex
			})
		end, {}),
		fireConversationImpressionEvent = React.useCallback(function(p)
			if p == nil or p.id == nil then
				return
			end

			local chatLandingConversationInfo = getChatLandingConversationInfo(
				p,
				ref.current or {},
				ref2.current == true
			)
			ref3.current(ChatLandingTelemetryEvents.ConversationCellRendered, chatLandingConversationInfo)
			ref3.current(ChatLandingTelemetryEvents.ConversationCellRenderedIndexStat, {
				statValue = chatLandingConversationInfo.selectedIndex
			})
		end, {})
	}
end

return useFriendsChatLandingTelemetry
