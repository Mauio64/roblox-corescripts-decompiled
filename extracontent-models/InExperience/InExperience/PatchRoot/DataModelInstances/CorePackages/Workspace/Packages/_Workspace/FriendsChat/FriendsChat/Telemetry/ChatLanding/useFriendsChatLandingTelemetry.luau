local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local ChatLandingTelemetryEvents = require(Parent.AppChat.ChatLandingTelemetryEvents)
local ChatLandingTelemetryLayer = require(Parent.AppChat.ChatLandingTelemetryLayer)
local ChatLandingTelemetryState = require(Parent.AppChat.ChatLandingTelemetryState)

require(Parent.AppChat.GetConversationListStore)

local GetFriendsChatSettingsStore = require(Parent.AppChat.GetFriendsChatSettingsStore)
local useTelemetry = require(Parent.AppChat.useTelemetry)
local getChatLandingConversationInfo = require(script.Parent.getChatLandingConversationInfo)
local getChatLandingSharedCounts = require(script.Parent.getChatLandingSharedCounts)

local function getIsChatEnabled() -- line: 24
	-- upvalues: GetFriendsChatSettingsStore (copy)
	return GetFriendsChatSettingsStore(false).getChatEnabled(false)
end
local function useFriendsChatLandingTelemetry(t1: {[any]: any}) -- line: 42
	-- upvalues: useTelemetry (copy), ChatLandingTelemetryLayer (copy), ChatLandingTelemetryState (copy), React (copy), getChatLandingSharedCounts (copy), ChatLandingTelemetryEvents (copy), GetFriendsChatSettingsStore (copy), getChatLandingConversationInfo (copy)
	local emit = useTelemetry(ChatLandingTelemetryLayer.Context).emit
	local v14 = ChatLandingTelemetryState.useSetState()
	local v15 = React.useRef(t1.displayedConversations)

	v15.current = t1.displayedConversations

	local v16 = React.useRef(t1.isFiltered)

	v16.current = t1.isFiltered

	local v17 = React.useRef(emit)

	v17.current = emit

	local v18 = React.useMemo(function() -- line: 56
		-- upvalues: getChatLandingSharedCounts (copy), t1 (copy)
		return getChatLandingSharedCounts(t1.conversations)
	end, { t1.conversations })

	React.useEffect(function() -- line: 60
		-- upvalues: v14 (copy), v18 (copy)
		v14(function(p1) -- line: 61
			-- upvalues: v18 (copy)
			local v30 = table.clone(p1)

			v30.chatLandingListCount = v18.chatLandingListCount
			v30.pendingConversationCount = v18.pendingConversationCount
			v30.unfilteredConversationCount = v18.unfilteredConversationCount

			return v30
		end)
	end, {
		v18,
		v14
	})
	React.useEffect(function() -- line: 74
		-- upvalues: v17 (copy), ChatLandingTelemetryEvents (copy), GetFriendsChatSettingsStore (copy)
		v17.current(ChatLandingTelemetryEvents.ScreenRendered, {
			isChatEnabled = GetFriendsChatSettingsStore(false).getChatEnabled(false)
		})
	end, {})

	local v19 = React.useCallback(function() -- line: 80
		-- upvalues: v17 (copy), ChatLandingTelemetryEvents (copy)
		v17.current(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
	end, {})
	local v20 = React.useCallback(function(p2, _, s1: string?) -- line: 85
		-- upvalues: getChatLandingConversationInfo (copy), v15 (copy), v16 (copy), v17 (copy), ChatLandingTelemetryEvents (copy)
		if p2 == nil or p2.id == nil then
			return
		end

		local v25 = getChatLandingConversationInfo(p2, v15.current or {}, v16.current == true)
		local v26 = table.clone(v25)

		v26.osaImpressionId = s1
		v17.current(ChatLandingTelemetryEvents.ConversationClicked, v26)
		v17.current(ChatLandingTelemetryEvents.ConversationClickedIndexStat, {
			statValue = v25.selectedIndex
		})
	end, {})
	local v21 = React.useCallback(function(p4) -- line: 104
		-- upvalues: getChatLandingConversationInfo (copy), v15 (copy), v16 (copy), v17 (copy), ChatLandingTelemetryEvents (copy)
		if p4 == nil or p4.id == nil then
			return
		end

		local v28 = getChatLandingConversationInfo(p4, v15.current or {}, v16.current == true)

		v17.current(ChatLandingTelemetryEvents.ConversationCellRendered, v28)
		v17.current(ChatLandingTelemetryEvents.ConversationCellRenderedIndexStat, {
			statValue = v28.selectedIndex
		})
	end, {})

	return {
		fireSearchActivatedEvent = v19,
		fireConversationClickedEvent = v20,
		fireConversationImpressionEvent = v21
	}
end

return useFriendsChatLandingTelemetry
