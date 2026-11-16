local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local ViewRecyclerReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ViewRecyclerReact")

local EnumMessageTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EnumMessageTypes")
local isScrolledAwayFromLatest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ScrollToLatest/isScrolledAwayFromLatest")
local GetConversationMessageViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageViewModelStore")
local ListItems = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/MessageListV2/ListItems")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/MessageListV2/MessageListContext")
local MessageRowTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/MessageListV2/MessageRowTypes")
local useDelayedScrollToStart = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/MessageListV2/useDelayedScrollToStart")
local useInitialScrollAlignment = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/MessageListV2/useInitialScrollAlignment")
local useMessageListLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/MessageListV2/useMessageListLayout")
local useViewportResizeCompensation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/MessageListV2/useViewportResizeCompensation")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local createScrollIntervalTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/createScrollIntervalTracker")

local FFlagAppChatConversationLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConversationLoadingSkeleton")
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatScrollToLatest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatScrollToLatest")
local FIntAppChatInitialMessageFetchLimit = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatInitialMessageFetchLimit")
local FFlagAppChatMessageListV2ScrollToStartOnOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageListV2ScrollToStartOnOpen")
local FFlagAppChatMessageListV2StableRowCallbacks = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageListV2StableRowCallbacks")
local FFlagAppChatMessageListV2ScrollParity = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageListV2ScrollParity")
local FFlagAppChatMessageListV2FollowIncoming = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageListV2FollowIncoming")
local FFlagAppChatMessageListV2ShowBeforeMeasured = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageListV2ShowBeforeMeasured")
local FIntAppChatMessageListV2OverscanRows = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatMessageListV2OverscanRows")

local FIntAppChatMessageListV2StartReachedViewports = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatMessageListV2StartReachedViewports")
local FIntAppChatMessageInitialFetchMinMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatMessageInitialFetchMinMessages")

local v5 = { viewportFraction = math.max(0, FIntAppChatMessageListV2StartReachedViewports) }

local function noop() end

local function isIncomingChatMessage(p2): boolean
	return p2.isIncoming == true and (p2.messageType == EnumMessageTypes.PlainText or p2.messageType == EnumMessageTypes.Link)
end

local function findNewestIncomingChatMessageId(list)
	for i = #list, 1, -1 do
		local item = list[i]
		local v6

		if item.isIncoming == true then
			v6 = item.messageType == EnumMessageTypes.PlainText or item.messageType == EnumMessageTypes.Link
		else
			v6 = false
		end

		if v6 then
			return list[i].messageId
		end
	end

	return nil
end

local function useStableRowCallbacks(ref, p2)
	local v6 = React.useMemo(function()
		local function forward(p3)
			return function(...)
				local v7 = ref.current[p3]

				if v7 == nil then
					return nil
				end

				return v7(...)
			end
		end
		local v8 = "closeKeyboard"
		local v7 = {
			closeKeyboard = function(...)
				local v9 = ref.current[v8]

				if v9 == nil then
					return nil
				end

				return v9(...)
			end,
			onDetailsOpened = 0,
			openGameDetailsPage = 0,
			openMomentsDeepLink = 0,
			openViewProfile = 0
		}
		local v9 = "onDetailsOpened"
		function v7.onDetailsOpened(...)
			local v10 = ref.current[v9]

			if v10 == nil then
				return nil
			end

			return v10(...)
		end

		local v10 = "openGameDetailsPage"
		function v7.openGameDetailsPage(...)
			local v11 = ref.current[v10]

			if v11 == nil then
				return nil
			end

			return v11(...)
		end

		local v11 = "openMomentsDeepLink"
		function v7.openMomentsDeepLink(...)
			local v12 = ref.current[v11]

			if v12 == nil then
				return nil
			end

			return v12(...)
		end

		local v12 = "openViewProfile"
		function v7.openViewProfile(...)
			local v13 = ref.current[v12]

			if v13 == nil then
				return nil
			end

			return v13(...)
		end
		return v7
	end, {})
	local v7 = {
		closeKeyboard = v6.closeKeyboard,
		onDetailsOpened = v6.onDetailsOpened,
		openGameDetailsPage = v6.openGameDetailsPage,
		openMomentsDeepLink = 0,
		openViewProfile = 0
	}
	local v8 = if p2 then v6.openMomentsDeepLink else nil
	v7.openMomentsDeepLink = v8
	v7.openViewProfile = v6.openViewProfile
	return v7
end

local function useMessageListV2ViewModel(current)
	local ref = React.useRef(current)
	ref.current = current
	local conversationId = current.conversationId

	local ref2 = React.useRef(nil)
	local v6 = React.useMemo(function()
		return ListItems.build(current.itemList, ref2.current)
	end, { current.itemList })
	ref2.current = v6
	local items = v6.items
	local count = #items

	local ref3 = React.useRef(nil)

	if ref3.current == nil then
		local flag = true
		local messageId

		for i = #items, 1, -1 do
			local item = items[i]
			local v7

			if item.isIncoming == true then
				v7 = item.messageType == EnumMessageTypes.PlainText or item.messageType == EnumMessageTypes.Link
			else
				v7 = false
			end

			if v7 then
				messageId = items[i].messageId
				flag = false
				break
			end
		end

		if flag then
			messageId = nil
		end

		ref3.current = messageId
	end

	local current2 = ref3.current

	local ref4 = React.useRef(count)
	React.useEffect(function()
		if FFlagAppChatPerfTracking and count > ref4.current then
			AppChatPerfTracker.finish(AppChatPerfTracker.Events.PaginationMessageList, {
				conversationId = conversationId
			})
		end

		ref4.current = count
	end, { count, conversationId })

	local ref5 = React.useRef(0)

	local item = items[count]
	local v7 = if item ~= nil then ListItems.getKey(item) else nil
	local ref6 = React.useRef(v7)
	React.useEffect(function()
		local current3 = ref6.current
		ref6.current = v7

		if current3 ~= nil and v7 ~= nil and v7 ~= current3 and ref5.current < 64 then
			ref.current.markAsRead()
		end
	end, { v7 })

	local ref7 = React.useRef(nil)

	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p2): boolean
			local metadata = GetConversationMessageViewModelStore(false).conversationMessageListStore.getMetadata(conversationId, p2)
			return metadata ~= nil and metadata.isLoading == true
		end)
	end, { conversationId })
	local v9 = SignalsReact.useSignalState(v8)
	React.useEffect(function()
		if not v9 then
			ref7.current = nil
		end
	end, { v9 })
	local v10 = React.useCallback(function()
		local loadNext = ref.current.loadNext

		if loadNext == nil then
			return
		end

		local items2 = ref2.current.items
		local item2 = items2[1]
		local formatted = `{#items2}:{item2 == nil and "" or module8.getKey(item2)}`

		if ref7.current == formatted then
			return
		end

		ref7.current = formatted

		if FFlagAppChatPerfTracking then
			AppChatPerfTracker.start(AppChatPerfTracker.Events.PaginationMessageList, {
				conversationId = conversationId
			})
		end

		loadNext()
	end, { conversationId })

	local openAtStart = current.openAtStart == true
	local v11 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local conversationMessageListStore = GetConversationMessageViewModelStore(false).conversationMessageListStore
			local metadata = conversationMessageListStore.getMetadata(conversationId, p2)

			if metadata ~= nil and metadata.fetchedOldest == true then
				return nil
			end

			local count2 = #conversationMessageListStore.getOrderedIds(conversationId, p2)

			if openAtStart or not (FIntAppChatMessageInitialFetchMinMessages <= count2) then
				return count2
			end

			return nil
		end)
	end, { conversationId, openAtStart })
	local v12 = SignalsReact.useSignalState(v11)
	local v13 = current.loadNext ~= nil
	local v14 = v13 and v12 ~= nil
	local ref8 = React.useRef(0)

	local ref9 = React.useRef(nil)
	local ref10 = React.useRef(false)
	local state, setState = React.useState(false)
	React.useEffect(function()
		if v14 and not openAtStart and ref8.current < FIntAppChatInitialMessageFetchLimit then
			ref8.current += 1
			ref9.current = v12
			ref10.current = false
			v10()

			local metadata = GetConversationMessageViewModelStore(false).conversationMessageListStore.getMetadata(conversationId)

			if metadata == nil or metadata.isLoading ~= true then
				setState(true)
			end
		end
	end, { conversationId, v12, v14, openAtStart, v10 })
	React.useEffect(function()
		if v9 then
			ref10.current = true
		elseif ref10.current then
			if v12 == ref9.current then
				setState(true)
			elseif FIntAppChatInitialMessageFetchLimit <= ref8.current then
				setState(true)
			end
		end
	end, { v9, v12 })

	local ref11 = React.useRef(nil)
	local ref12 = React.useRef(nil)
	local state2, setState2 = React.useState(nil)

	local v15 = if FFlagAppChatMessageListV2ScrollParity then useViewportResizeCompensation(ref11, state2) else nil

	React.useEffect(function()
		if not FFlagAppChatPerfTracking or state2 == nil then
			return nil
		end

		local v16 = createScrollIntervalTracker(AppChatPerfTracker.Events.ScrollMessageList, state2, {
			conversationId = conversationId
		})

		ref12.current = v16
		return function()
			v16.cleanup()
			ref12.current = nil
		end
	end, { state2, conversationId })

	local ref13 = React.useRef(false)
	local v16 = React.useCallback(function(p2)
		local onScrolledAwayFromLatestChanged = ref.current.onScrolledAwayFromLatestChanged

		if onScrolledAwayFromLatestChanged == nil then
			return
		end

		local v17 = isScrolledAwayFromLatest(p2.distanceFromEnd, p2.viewportLength)

		if v17 ~= ref13.current then
			ref13.current = v17
			onScrolledAwayFromLatestChanged(v17)
		end
	end, {})

	local scrollToLatestRef = current.scrollToLatestRef
	React.useEffect(function()
		if not FFlagAppChatScrollToLatest or scrollToLatestRef == nil then
			return nil
		end

		local function scrollToLatest()
			local current3 = ref11.current

			if current3 ~= nil then
				current3.scrollToEnd()
			end
		end
		scrollToLatestRef.current = scrollToLatest
		return function()
			if scrollToLatestRef.current == scrollToLatest then
				scrollToLatestRef.current = nil
			end
		end
	end, { scrollToLatestRef })

	local v17 = React.useCallback(function()
		if ref12.current ~= nil then
			ref12.current.onScrollTick()
		end

		local current3 = ref11.current

		if current3 == nil then
			return
		end

		local scrollState = current3.getScrollState()
		local distanceFromEnd = scrollState.distanceFromEnd
		ref5.current = distanceFromEnd

		if v15 ~= nil then
			v15.onScrolled(distanceFromEnd)
		end

		if distanceFromEnd < 64 and #ref2.current.items > 0 then
			ref.current.markAsRead()
		end

		if FFlagAppChatScrollToLatest then
			v16(scrollState)
		end
	end, { v15 })

	local v18 = React.useCallback(function()
		local current3 = ref11.current

		if current3 ~= nil then
			v16(current3.getScrollState())
		end
	end, {})
	local v19 = React.useCallback(function()
		if v15 ~= nil then
			v15.onContentLengthChanged()
		end

		v18()
	end, { v15 })

	local readingMessagesIsEnabled = current.readingMessagesIsEnabled
	local ref14 = React.useRef(readingMessagesIsEnabled)
	React.useEffect(function()
		local current3 = ref14.current
		ref14.current = readingMessagesIsEnabled

		if readingMessagesIsEnabled and not current3 and ref5.current < 64 then
			ref.current.markAsRead()
		end
	end, { readingMessagesIsEnabled })

	local state3, setState3 = React.useState(0)
	local v20 = React.useCallback(function(p2)
		setState3(p2.X)

		if v15 ~= nil then
			v15.onViewportChanged(p2.Y)
		end

		if FFlagAppChatScrollToLatest then
			v18()
		end
	end, { v15 })

	local v21 = React.useCallback(function(p2)
		if p2 ~= nil then
			p2.Selectable = false
		end

		if v15 ~= nil then
			v15.onScrollingFrameChanged(p2)
		end

		setState2(p2)
	end, { v15 })

	local v22 = current.isInitialMessageLoading == true or v14 and (openAtStart or not state)

	local ref15 = React.useRef(nil)

	if ref15.current == nil and not v22 then
		local v23 = if openAtStart then ViewRecyclerReact.ScrollAlignment.Start else ViewRecyclerReact.ScrollAlignment.End
		ref15.current = v23
	end

	local v23 = ref15.current

	local ref16 = React.useRef(v6.byKey)
	local ref17 = React.useRef(false)

	local ref18 = React.useRef(nil)
	local ref19 = React.useRef(nil)

	if FFlagAppChatMessageListV2FollowIncoming and ref19.current ~= v6 then
		ref19.current = v6
		local current3 = ref11.current
		local v24 = if current3 ~= nil then current3.getScrollState().distanceFromEnd else nil
		ref18.current = v24
	end

	React.useEffect(function()
		local current3 = ref16.current
		ref16.current = v6.byKey
		local current4 = ref17.current
		ref17.current = not v22
		local item2 = v6.items[#v6.items]
		local current5 = ref11.current

		if current4 and current5 ~= nil and item2 ~= nil and current3[ListItems.getKey(item2)] == nil then
			local current6 = ref18.current

			if item2.isIncoming == true then
				if FFlagAppChatMessageListV2FollowIncoming and current6 ~= nil and current6 < 33 then
					current5.scrollToEnd()
				end
			else
				current5.scrollToEnd()
			end
		end
	end, { v6, v22 })

	if FFlagAppChatMessageListV2ScrollToStartOnOpen then
		v23 = useInitialScrollAlignment(openAtStart, v22, ref11, state2)
	end

	if FFlagAppChatMessageListV2ScrollParity then
		useDelayedScrollToStart(openAtStart, v22, ref11)
	end

	local state4, setState4 = React.useState(false)
	local v24 = React.useCallback(function()
		setState4(true)
	end, {})

	if FFlagAppChatMessageListV2ShowBeforeMeasured then
		v24 = nil
	end

	local v26 = useMessageListLayout(v24)

	local ref20 = React.useRef(false)

	local v27 = FFlagAppChatMessageListV2ShowBeforeMeasured or ref20.current or state4 or count == 0

	if not v22 then
		ref20.current = v27
	end

	local v28 = React.useMemo(function()
		local clone = table.clone(ViewRecyclerReact.ChatPreset.create({
			startReachedThreshold = v5
		}))

		clone.initialScrollAlignment = v23 or clone.initialScrollAlignment
		clone.data = { items = items, getItemKey = ListItems.getKey }

		clone.layout = v26
		clone.axis = ViewRecyclerReact.Axis.Y
		clone.itemType = MessageRowTypes.MessageRowType
		clone.pinnedEndItem = MessageRowTypes.EndSpacerItem
		clone.listRef = ref11
		clone.overscan = FIntAppChatMessageListV2OverscanRows
		clone.onStartReached = if v13 then v10 else nil
		clone.onScrollOffsetChanged = v17

		if v15 ~= nil then
			clone.onContentLengthChanged = v15.onContentLengthChanged
		end

		if FFlagAppChatScrollToLatest then
			clone.onContentLengthChanged = v19
		end

		clone.onViewportChanged = v20
		clone.scrollingFrameRef = v21
		clone.scrollingFrameProps = {
			Name = "MessageList",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			Visible = v27
		}

		return clone
	end, {
		v21,
		v13,
		v23,
		v27,
		items,
		v26,
		v19,
		v17,
		v20,
		v10,
		v15
	})
	local v29

	if FFlagAppChatMessageListV2StableRowCallbacks then
		v29 = useStableRowCallbacks(ref, current.openMomentsDeepLink ~= nil)
	else
		v29 = current
	end

	return {
		contextValue = React.useMemo(function()
			return {
				conversationId = conversationId,
				width = state3,
				wideMode = current.wideMode == true,
				isDebugEnabled = current.isDebugEnabled == true,
				lastIncomingChatMessageId = current2,
				viewProfileOnAvatarPressed = current.viewProfileOnAvatarPressed ~= false,
				inputBoxRef = current.inputBoxRef,
				closeKeyboard = v29.closeKeyboard or noop,
				onDetailsOpened = v29.onDetailsOpened or noop,
				openGameDetailsPage = v29.openGameDetailsPage or noop,
				openMomentsDeepLink = v29.openMomentsDeepLink,
				openViewProfile = v29.openViewProfile or noop,
				invalidMessageTypeText = current.invalidMessageTypeText,
				messageDefaultNoticeText = current.messageDefaultNoticeText,
				messageModeratedNoticeText = current.messageModeratedNoticeText,
				messageHiddenNoticeText = current.messageHiddenNoticeText,
				unknownUserText = current.unknownUserText
			}
		end, {
			conversationId,
			state3,
			current2,
			current.wideMode,
			current.isDebugEnabled,
			current.viewProfileOnAvatarPressed,
			current.inputBoxRef,
			v29.closeKeyboard,
			v29.onDetailsOpened,
			v29.openGameDetailsPage,
			v29.openMomentsDeepLink,
			v29.openViewProfile,
			current.invalidMessageTypeText,
			current.messageDefaultNoticeText,
			current.messageModeratedNoticeText,
			current.messageHiddenNoticeText,
			current.unknownUserText
		}),
		listProps = v28,
		isLoading = v22,
		isListVisible = v27,
		showLoadingSkeleton = FFlagAppChatConversationLoadingSkeleton
	}
end

return useMessageListV2ViewModel
