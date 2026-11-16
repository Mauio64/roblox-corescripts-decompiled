local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local ViewRecycler = require(parent.ViewRecycler)

local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)
local isScrolledAwayFromLatest = require(AppChat.Components.ChatConversation.ScrollToLatest.isScrolledAwayFromLatest)
local GetConversationMessageViewModelStore = require(AppChat.Stores.GetConversationMessageViewModelStore)
local ListItems = require(script.Parent.ListItems)
require(script.Parent.MessageListContext)
local MessageRowTypes = require(script.Parent.MessageRowTypes)
local useDelayedScrollToStart = require(script.Parent.useDelayedScrollToStart)
local useInitialScrollAlignment = require(script.Parent.useInitialScrollAlignment)
local useMessageListLayout = require(script.Parent.useMessageListLayout)
local useViewportResizeCompensation = require(script.Parent.useViewportResizeCompensation)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local createScrollIntervalTracker = require(AppChat.Telemetry.createScrollIntervalTracker)

local FFlagAppChatConversationLoadingSkeleton = require(AppChat.Flags.FFlagAppChatConversationLoadingSkeleton)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatScrollToLatest = require(AppChat.Flags.FFlagAppChatScrollToLatest)
local FIntAppChatInitialMessageFetchLimit = require(AppChat.Flags.FIntAppChatInitialMessageFetchLimit)
local FFlagAppChatMessageListV2ScrollToStartOnOpen = require(AppChat.Flags.FFlagAppChatMessageListV2ScrollToStartOnOpen)
local FFlagAppChatMessageListV2StableRowCallbacks = require(AppChat.Flags.FFlagAppChatMessageListV2StableRowCallbacks)
local FFlagAppChatMessageListV2ScrollParity = require(AppChat.Flags.FFlagAppChatMessageListV2ScrollParity)
local FFlagAppChatMessageListV2FollowIncoming = require(AppChat.Flags.FFlagAppChatMessageListV2FollowIncoming)
local FFlagAppChatMessageListV2ShowBeforeMeasured = require(AppChat.Flags.FFlagAppChatMessageListV2ShowBeforeMeasured)
local FIntAppChatMessageListV2OverscanRows = require(AppChat.Flags.FIntAppChatMessageListV2OverscanRows)

local FIntAppChatMessageListV2StartReachedViewports = require(AppChat.Flags.FIntAppChatMessageListV2StartReachedViewports)
local FIntAppChatMessageInitialFetchMinMessages = require(AppChat.Flags.FIntAppChatMessageInitialFetchMinMessages)

local startReachedThreshold = {
	viewportFraction = math.max(0, FIntAppChatMessageListV2StartReachedViewports)
}

local function noop() end

local function isIncomingChatMessage(p): boolean -- 1 equivalent call inferred from this helper
	return p.isIncoming == true
		and (p.messageType == EnumMessageTypes.PlainText or p.messageType == EnumMessageTypes.Link)
end

local function findNewestIncomingChatMessageId(items) -- 1 equivalent call inferred from this helper
	for i = #items, 1, -1 do
		if isIncomingChatMessage(items[i]) then -- inferred equivalent call
			return items[i].messageId
		end
	end

	return nil
end

local function useStableRowCallbacks(ref, flag: boolean)
	local v = React.useMemo(function()
		local function forward(p: string) -- 5 equivalent calls inferred from this helper
			return function(...)
				local v = ref.current[p]

				if v == nil then
					return nil
				end

				return v(...)
			end
		end

		return {
			closeKeyboard = forward("closeKeyboard"), -- inferred equivalent call
			onDetailsOpened = forward("onDetailsOpened"), -- inferred equivalent call
			openGameDetailsPage = forward("openGameDetailsPage"), -- inferred equivalent call
			openMomentsDeepLink = forward("openMomentsDeepLink"), -- inferred equivalent call
			openViewProfile = forward("openViewProfile") -- inferred equivalent call
		}
	end, {})
	local v2 = {
		closeKeyboard = v.closeKeyboard,
		onDetailsOpened = v.onDetailsOpened,
		openGameDetailsPage = v.openGameDetailsPage,
		openMomentsDeepLink = 0,
		openViewProfile = 0
	}
	local openMomentsDeepLink

	if flag then
		openMomentsDeepLink = v.openMomentsDeepLink
	end

	v2.openMomentsDeepLink = openMomentsDeepLink
	v2.openViewProfile = v.openViewProfile
	return v2
end

local function useMessageListV2ViewModel(current)
	local ref = React.useRef(current)
	ref.current = current
	local conversationId = current.conversationId

	local ref2 = React.useRef(nil)
	local current7 = React.useMemo(function()
		return ListItems.build(current.itemList, ref2.current)
	end, { current.itemList })
	ref2.current = current7
	local items = current7.items
	local count = #items

	local ref3 = React.useRef(nil)

	if ref3.current == nil then
		ref3.current = findNewestIncomingChatMessageId(items) -- inferred equivalent call
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
	local current8

	if item == nil then
		current8 = nil
	else
		current8 = ListItems.getKey(item)
	end

	local ref6 = React.useRef(current8)
	React.useEffect(function()
		local current3 = ref6.current
		ref6.current = current8

		if current3 ~= nil and current8 ~= nil and current8 ~= current3 and ref5.current < 64 then
			ref.current.markAsRead()
		end
	end, { current8 })

	local ref7 = React.useRef(nil)

	local v = React.useMemo(function()
		return Signals.createComputed(function(p): boolean
			local metadata = GetConversationMessageViewModelStore(false).conversationMessageListStore.getMetadata(
				conversationId,
				p
			)
			return metadata ~= nil and metadata.isLoading == true
		end)
	end, { conversationId })
	local v2 = SignalsReact.useSignalState(v)
	React.useEffect(function()
		if not v2 then
			ref7.current = nil
		end
	end, { v2 })
	local v3 = React.useCallback(function()
		local loadNext = ref.current.loadNext

		if loadNext == nil then
			return
		end

		local items2 = ref2.current.items
		local item2 = items2[1]
		local formatted = `{#items2}:{item2 == nil and "" or ListItems.getKey(item2)}`

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
	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p)
			local conversationMessageListStore = GetConversationMessageViewModelStore(false).conversationMessageListStore
			local metadata = conversationMessageListStore.getMetadata(conversationId, p)

			if metadata ~= nil and metadata.fetchedOldest == true then
				return nil
			end

			local count2 = #conversationMessageListStore.getOrderedIds(conversationId, p)

			if openAtStart or not (FIntAppChatMessageInitialFetchMinMessages <= count2) then
				return count2
			end

			return nil
		end)
	end, { conversationId, openAtStart })
	local current9 = SignalsReact.useSignalState(v4)
	local v5 = current.loadNext ~= nil
	local v6 = v5 and current9 ~= nil
	local ref8 = React.useRef(0)

	local ref9 = React.useRef(nil)
	local ref10 = React.useRef(false)
	local state, setState = React.useState(false)
	React.useEffect(function()
		if v6 and not openAtStart and ref8.current < FIntAppChatInitialMessageFetchLimit then
			ref8.current += 1
			ref9.current = current9
			ref10.current = false
			v3()

			local metadata = GetConversationMessageViewModelStore(false).conversationMessageListStore.getMetadata(conversationId)

			if metadata == nil or metadata.isLoading ~= true then
				setState(true)
			end
		end
	end, { conversationId, current9, v6, openAtStart, v3 })
	React.useEffect(function()
		if v2 then
			ref10.current = true
		elseif ref10.current and (current9 == ref9.current or FIntAppChatInitialMessageFetchLimit <= ref8.current) then
			setState(true)
		end
	end, { v2, current9 })

	local ref11 = React.useRef(nil)
	local ref12 = React.useRef(nil)
	local state2, setState2 = React.useState(nil)
	local v7

	if FFlagAppChatMessageListV2ScrollParity then
		v7 = useViewportResizeCompensation(ref11, state2)
	else
		v7 = nil
	end

	React.useEffect(function()
		if not FFlagAppChatPerfTracking or state2 == nil then
			return nil
		end

		local scrollIntervalTracker = createScrollIntervalTracker(AppChatPerfTracker.Events.ScrollMessageList, state2, {
			conversationId = conversationId
		})

		ref12.current = scrollIntervalTracker
		return function()
			scrollIntervalTracker.cleanup()
			ref12.current = nil
		end
	end, { state2, conversationId })

	local ref13 = React.useRef(false)
	local v8 = React.useCallback(function(p)
		local onScrolledAwayFromLatestChanged = ref.current.onScrolledAwayFromLatestChanged

		if onScrolledAwayFromLatestChanged == nil then
			return
		end

		local scrolledAwayFromLatest = isScrolledAwayFromLatest(p.distanceFromEnd, p.viewportLength)

		if scrolledAwayFromLatest ~= ref13.current then
			ref13.current = scrolledAwayFromLatest
			onScrolledAwayFromLatestChanged(scrolledAwayFromLatest)
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

	local onScrollOffsetChanged = React.useCallback(function()
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

		if v7 ~= nil then
			v7.onScrolled(distanceFromEnd)
		end

		if distanceFromEnd < 64 and #ref2.current.items > 0 then
			ref.current.markAsRead()
		end

		if FFlagAppChatScrollToLatest then
			v8(scrollState)
		end
	end, { v7 })

	local v9 = React.useCallback(function()
		local current3 = ref11.current

		if current3 ~= nil then
			v8(current3.getScrollState())
		end
	end, {})
	local onContentLengthChanged = React.useCallback(function()
		if v7 ~= nil then
			v7.onContentLengthChanged()
		end

		v9()
	end, { v7 })

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
	local onViewportChanged = React.useCallback(function(vector2: Vector2)
		setState3(vector2.X)

		if v7 ~= nil then
			v7.onViewportChanged(vector2.Y)
		end

		if FFlagAppChatScrollToLatest then
			v9()
		end
	end, { v7 })

	local scrollingFrameRef = React.useCallback(function(p)
		if p ~= nil then
			p.Selectable = false
		end

		if v7 ~= nil then
			v7.onScrollingFrameChanged(p)
		end

		setState2(p)
	end, { v7 })

	local isLoading = current.isInitialMessageLoading == true or v6 and (openAtStart or not state)

	local ref15 = React.useRef(nil)

	if ref15.current == nil and not isLoading then
		local current3

		if openAtStart then
			current3 = ViewRecycler.ScrollAlignment.Start
		else
			current3 = ViewRecycler.ScrollAlignment.End
		end

		ref15.current = current3
	end

	local v10 = ref15.current

	local ref16 = React.useRef(current7.byKey)
	local ref17 = React.useRef(false)

	local ref18 = React.useRef(nil)
	local ref19 = React.useRef(nil)

	if FFlagAppChatMessageListV2FollowIncoming and ref19.current ~= current7 then
		ref19.current = current7
		local current3 = ref11.current
		local current4

		if current3 ~= nil then
			current4 = current3.getScrollState().distanceFromEnd
		end

		ref18.current = current4
	end

	React.useEffect(function()
		local current3 = ref16.current
		ref16.current = current7.byKey
		local current4 = ref17.current
		ref17.current = not isLoading
		local item2 = current7.items[#current7.items]
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
	end, { current7, isLoading })

	if FFlagAppChatMessageListV2ScrollToStartOnOpen then
		v10 = useInitialScrollAlignment(openAtStart, isLoading, ref11, state2)
	end

	if FFlagAppChatMessageListV2ScrollParity then
		useDelayedScrollToStart(openAtStart, isLoading, ref11)
	end

	local state4, setState4 = React.useState(false)
	local v11 = React.useCallback(function()
		setState4(true)
	end, {})

	if FFlagAppChatMessageListV2ShowBeforeMeasured then
		v11 = nil
	end

	local layout = useMessageListLayout(v11)

	local ref20 = React.useRef(false)

	local v12 = FFlagAppChatMessageListV2ShowBeforeMeasured or ref20.current or state4 or count == 0

	if not isLoading then
		ref20.current = v12
	end

	local listProps = React.useMemo(function()
		local clone = table.clone(ViewRecycler.ChatPreset.create({
			startReachedThreshold = startReachedThreshold
		}))

		clone.initialScrollAlignment = v10 or clone.initialScrollAlignment
		clone.data = { items = items, getItemKey = ListItems.getKey }

		clone.layout = layout
		clone.axis = ViewRecycler.Axis.Y
		clone.itemType = MessageRowTypes.MessageRowType
		clone.pinnedEndItem = MessageRowTypes.EndSpacerItem
		clone.listRef = ref11
		clone.overscan = FIntAppChatMessageListV2OverscanRows
		local onStartReached

		if v5 then
			onStartReached = v3
		end

		clone.onStartReached = onStartReached
		clone.onScrollOffsetChanged = onScrollOffsetChanged

		if v7 ~= nil then
			clone.onContentLengthChanged = v7.onContentLengthChanged
		end

		if FFlagAppChatScrollToLatest then
			clone.onContentLengthChanged = onContentLengthChanged
		end

		clone.onViewportChanged = onViewportChanged
		clone.scrollingFrameRef = scrollingFrameRef
		clone.scrollingFrameProps = {
			Name = "MessageList",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			Visible = v12
		}

		return clone
	end, {
		scrollingFrameRef,
		v5,
		v10,
		v12,
		items,
		layout,
		onContentLengthChanged,
		onScrollOffsetChanged,
		onViewportChanged,
		v3,
		v7
	})
	local v13

	if FFlagAppChatMessageListV2StableRowCallbacks then
		v13 = useStableRowCallbacks(ref, current.openMomentsDeepLink ~= nil)
	else
		v13 = current
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
				closeKeyboard = v13.closeKeyboard or noop,
				onDetailsOpened = v13.onDetailsOpened or noop,
				openGameDetailsPage = v13.openGameDetailsPage or noop,
				openMomentsDeepLink = v13.openMomentsDeepLink,
				openViewProfile = v13.openViewProfile or noop,
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
			v13.closeKeyboard,
			v13.onDetailsOpened,
			v13.openGameDetailsPage,
			v13.openMomentsDeepLink,
			v13.openViewProfile,
			current.invalidMessageTypeText,
			current.messageDefaultNoticeText,
			current.messageModeratedNoticeText,
			current.messageHiddenNoticeText,
			current.unknownUserText
		}),
		listProps = listProps,
		isLoading = isLoading,
		isListVisible = v12,
		showLoadingSkeleton = FFlagAppChatConversationLoadingSkeleton
	}
end

return useMessageListV2ViewModel
