local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local ChatLandingTelemetryEvents = require(Parent.AppChat.ChatLandingTelemetryEvents)
local ChatLandingTelemetryLayer = require(Parent.AppChat.ChatLandingTelemetryLayer)
local ChatLandingTelemetryState = require(Parent.AppChat.ChatLandingTelemetryState)

require(Parent.AppChat.GetConversationListStore)

local useTelemetry = require(Parent.AppChat.useTelemetry)
local getChatLandingConversationInfo = require(script.Parent.getChatLandingConversationInfo)
local getChatLandingSharedCounts = require(script.Parent.getChatLandingSharedCounts)

local function useFriendsChatLandingTelemetry(t1: {[any]: any}) -- line: 37
	-- upvalues: useTelemetry (copy), ChatLandingTelemetryLayer (copy), ChatLandingTelemetryState (copy), React (copy), getChatLandingSharedCounts (copy), ChatLandingTelemetryEvents (copy), getChatLandingConversationInfo (copy)
	local emit = useTelemetry(ChatLandingTelemetryLayer.Context).emit
	local v12 = ChatLandingTelemetryState.useSetState()
	local v13 = React.useRef(t1.displayedConversations)

	v13.current = t1.displayedConversations

	local v14 = React.useRef(t1.isFiltered)

	v14.current = t1.isFiltered

	local v15 = React.useRef(emit)

	v15.current = emit

	local v16 = React.useMemo(function() -- line: 51
		-- upvalues: getChatLandingSharedCounts (copy), t1 (copy)
		return getChatLandingSharedCounts(t1.conversations)
	end, { t1.conversations })

	React.useEffect(function() -- line: 55
		-- upvalues: v12 (copy), v16 (copy)
		v12(function(p1) -- line: 56
			-- upvalues: v16 (copy)
			local v28 = table.clone(p1)

			v28.chatLandingListCount = v16.chatLandingListCount
			v28.pendingConversationCount = v16.pendingConversationCount
			v28.unfilteredConversationCount = v16.unfilteredConversationCount

			return v28
		end)
	end, {
		v16,
		v12
	})
	React.useEffect(function() -- line: 69
		-- upvalues: v15 (copy), ChatLandingTelemetryEvents (copy)
		v15.current(ChatLandingTelemetryEvents.ScreenRendered, {
			isChatEnabled = true
		})
	end, {})

	local v17 = React.useCallback(function() -- line: 76
		-- upvalues: v15 (copy), ChatLandingTelemetryEvents (copy)
		v15.current(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
	end, {})
	local v18 = React.useCallback(function(p2, _, s1: string?) -- line: 81
		-- upvalues: getChatLandingConversationInfo (copy), v13 (copy), v14 (copy), v15 (copy), ChatLandingTelemetryEvents (copy)
		if p2 == nil or p2.id == nil then
			return
		end

		local v23 = getChatLandingConversationInfo(p2, v13.current or {}, v14.current == true)
		local v24 = table.clone(v23)

		v24.osaImpressionId = s1
		v15.current(ChatLandingTelemetryEvents.ConversationClicked, v24)
		v15.current(ChatLandingTelemetryEvents.ConversationClickedIndexStat, {
			statValue = v23.selectedIndex
		})
	end, {})
	local v19 = React.useCallback(function(p4) -- line: 100
		-- upvalues: getChatLandingConversationInfo (copy), v13 (copy), v14 (copy), v15 (copy), ChatLandingTelemetryEvents (copy)
		if p4 == nil or p4.id == nil then
			return
		end

		local v26 = getChatLandingConversationInfo(p4, v13.current or {}, v14.current == true)

		v15.current(ChatLandingTelemetryEvents.ConversationCellRendered, v26)
		v15.current(ChatLandingTelemetryEvents.ConversationCellRenderedIndexStat, {
			statValue = v26.selectedIndex
		})
	end, {})

	return {
		fireSearchActivatedEvent = v17,
		fireConversationClickedEvent = v18,
		fireConversationImpressionEvent = v19
	}
end

return useFriendsChatLandingTelemetry
