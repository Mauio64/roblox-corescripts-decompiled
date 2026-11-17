local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local React = require(parent.React)
local ReactIs = require(parent.ReactIs)
local ReactOtter = require(parent.ReactOtter)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local Promise = require(parent.Promise)
local useLocalization = Localization.Hooks.useLocalization

local AppChat = require(parent.AppChat)
local useConversationSearch = require(parent.AppChat.useConversationSearch)
local ChatPlacementContext = require(parent.AppChat.ChatPlacementContext)
local searchIntroducedConversationIds = require(parent.AppChat.searchIntroducedConversationIds)

local FFlagFriendsChatServerSideConversationSearch = require(FriendsChat.Flags.FFlagFriendsChatServerSideConversationSearch)

local FFlagFriendsChatUseViewRecyclerConversationList = require(FriendsChat.Flags.FFlagFriendsChatUseViewRecyclerConversationList)
local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsChatConversationListFocusNav = SharedFlags.FFlagFriendsChatConversationListFocusNav
local SharedFlags2 = require(parent.SharedFlags)
local FFlagExpChatTabShortcutNav = SharedFlags2.FFlagExpChatTabShortcutNav
local VirtualizedList = require(parent.VirtualizedList)
local BidirectionalFlatList = VirtualizedList.BidirectionalFlatList
local useChatPlatform = require(parent.ExpChatIntegration.useChatPlatform)
local useChatInputBarSettings = require(parent.ExpChatIntegration.useChatInputBarSettings)
local useInterpolatedClientSettings = require(parent.ExpChatIntegration.useInterpolatedClientSettings)
local useChatWindowSettings = require(parent.ExpChatIntegration.useChatWindowSettings)

local ExpChatConversationListAdapter = require(script.Parent.ExpChatConversationListAdapter)
local useFocusConversationList = require(script.Parent.useFocusConversationList)
local getConversationRowHeight = require(script.Parent.getConversationRowHeight)
local resolveListState = require(script.Parent.resolveListState)
local useConversationListPagination = require(script.Parent.useConversationListPagination)
local useChatWindowReport = require(script.Parent.Parent.Utils.useChatWindowReport)
local LayoutConstants = require(FriendsChat.LayoutConstants)
local useChatSearchSession = require(parent.AppChat.useChatSearchSession)
local useChatSearchResultsTelemetry = require(parent.AppChat.useChatSearchResultsTelemetry)
local FFlagAppChatSearchSessionTelemetry = require(parent.AppChat.FFlagAppChatSearchSessionTelemetry)
local FFlagAppChatSearchSendPlacement = require(parent.AppChat.FFlagAppChatSearchSendPlacement)

local useFriendsChatLandingTelemetry = require(script.Parent.Parent.Telemetry.ChatLanding.useFriendsChatLandingTelemetry)
local getLandingEmptyStateType = require(script.Parent.Parent.Telemetry.ChatLanding.getLandingEmptyStateType)

local ButtonVariant = Foundation.Enums.ButtonVariant
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local Text = Foundation.Text
local View = Foundation.View
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset
local useTokens = Foundation.Hooks.useTokens

local ConversationListViewRecycler = AppChat.Components.ChatLanding.ConversationListViewRecycler
local ConversationRow = AppChat.Components.ChatLanding.ConversationRow
local getConversationTitle = ExpChatConversationListAdapter.getConversationTitle
local useConversationList = AppChat.Hooks.useConversationList

local defineFastInt = game:DefineFastInt("FriendsChatConversationListAutoscrollToTopThreshold", 33)

local defineFastInt2 = game:DefineFastInt("FriendsChatConversationListInitialNumToRender", 8)

local defineFastInt3 = game:DefineFastInt("FriendsChatConversationListPaginationThresholdRows", 10)

local defineFastInt4 = game:DefineFastInt("FriendsChatConversationListScrollbarIdleHideMs", 1500)

local defineFastInt5 = game:DefineFastInt("FriendsChatConversationListScrollbarThickness", 8)
local defineFastInt6 = game:DefineFastInt("FriendsChatConversationListWindowSize", 2)
local FFlagFriendsChatScaleConversationRowHeight = require(FriendsChat.Flags.FFlagFriendsChatScaleConversationRowHeight)
local FFlagFriendsChatLandingTelemetryFields = require(FriendsChat.Flags.FFlagFriendsChatLandingTelemetryFields)

local v = not FFlagFriendsChatUseViewRecyclerConversationList
local v2 = defineFastInt4 / 1000
local v3 = {
	dampingRatio = 1,
	frequency = 2,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local v4 = {
	NoFriends = "Feature.Chat.Text.NoFriends",
	SearchPlaceholder = "CommonUI.Controls.Action.Search",
	Loading = "Feature.Chat.Label.Loading",
	NoChatFound = "Feature.Chat.Label.NoChatFound",
	SomethingWentWrong = "CommonUI.Messages.Response.SomethingWentWrong"
}

local function getColorStyle(color3, transparency) -- 3 equivalent calls inferred from this helper
	return { Color3 = color3, Transparency = transparency }
end

local function getTransparencyOrBindingValue(backgroundTransparency: number, transparencyValue) -- 1 equivalent call inferred from this helper
	if ReactIs.isBinding(transparencyValue) then
		return transparencyValue:map(function(p: number)
			return backgroundTransparency + p * (1 - backgroundTransparency)
		end)
	end

	return transparencyValue
end

local function getTextTransparency(textTransparency, transparency: number) -- 1 equivalent call inferred from this helper
	if ReactIs.isBinding(textTransparency) then
		return textTransparency:map(function(p: number)
			return transparency + p * (1 - transparency)
		end)
	end

	return transparency
end

local function mergeTransparency(transparency: number, items)
	local v5 = {}

	for _, item in items do
		if ReactIs.isBinding(item) then
			table.insert(v5, item)
		else
			transparency += (item or 0) * (1 - transparency)
		end
	end

	if #v5 == 0 then
		return transparency
	end

	return React.joinBindings(v5):map(function(items2)
		local v6 = transparency

		for _, item in items2 do
			v6 += item * (1 - v6)
		end

		return v6
	end)
end

local function normalizeSearchText(state: string?) -- 1 equivalent call inferred from this helper
	return string.lower(state or "")
end

local function containsSearchText(value: string?, p: string): boolean
	return p == "" or string.find(string.lower(value or ""), p, 1, true) ~= nil
end

local function FriendsChatConversationList(props)
	local v5 = useTokens()
	local v6

	if FFlagFriendsChatScaleConversationRowHeight then
		v6 = useTextSizeOffset()
	end

	local getTransparencyStore = useChatPlatform().getTransparencyStore
	local v7 = useChatWindowSettings()
	local v8 = React.useMemo(function()
		return {
			BackgroundColor3 = v7.ChatWindowBackgroundColor3,
			BackgroundTransparency = v7.ChatWindowBackgroundTransparency
		}
	end, { v7 })
	local chatWindowSettings = props.chatWindowSettings or v8
	local v9 = useLocalization(v4)
	local v10 = useInterpolatedClientSettings(chatWindowSettings)
	local backgroundTransparency = v10.BackgroundTransparency
	local backgroundColor3 = v10.BackgroundColor3 or v10.BackgroundColor or chatWindowSettings.BackgroundColor3
	local transparencyValue = props.transparencyValue or v7.ChatWindowBackgroundTransparency
	local groupTransparency

	if props.transparencyValue == nil then
		groupTransparency = 0
	elseif ReactIs.isBinding(transparencyValue) then
		local v11
		v11 = 0
		groupTransparency = transparencyValue:map(function(p: number)
			return v11 + p * (1 - v11)
		end)
	else
		groupTransparency = transparencyValue
	end

	local textTransparency = props.textTransparency or React.createBinding(0)

	local transparency = mergeTransparency(v5.Color.Content.Default.Transparency, {
		textTransparency,
		groupTransparency
	})

	local textTransparency2 = mergeTransparency(v5.Color.Content.Emphasis.Transparency, {
		textTransparency,
		groupTransparency
	})

	local transparency2 = mergeTransparency(v5.Color.Stroke.Default.Transparency, { groupTransparency })
	local size_1200 = v5.Size.Size_1200

	local conversationRowHeight = getConversationRowHeight(
		v5.Size.Size_1400,
		v6 or 0,
		FFlagFriendsChatScaleConversationRowHeight
	)

	local v11 = useChatInputBarSettings()
	local v12

	if props.isSpatialUIEnabled and v11 and v11.SpatialPanelTextSize then
		v12 = v11.SpatialPanelTextSize
	elseif v11 then
		v12 = v11.TextSize
	else
		v12 = v5.Typography.CaptionMedium.FontSize
	end

	local v13 = v12 or v5.Typography.CaptionMedium.FontSize
	local v14 = LayoutConstants.InputBarTopPadding + LayoutConstants.InputBarBottomPadding + LayoutConstants.InputBarTextVerticalPadding + v13

	local state, setState = React.useState("")
	local selectionImageObject

	if FFlagExpChatTabShortcutNav then
		selectionImageObject = Foundation.Hooks.useCursor(Foundation.Enums.CursorType.RoundedRect)
	end

	local ref = React.useRef(nil)

	local ref3, v15 = useFocusConversationList(getTransparencyStore)

	local visible = props.visible ~= false
	local v16 = useConversationList(visible)
	local v17 = useConversationListPagination(visible, v16.listStatus)
	local listStatus = v16.listStatus
	local items = v16.items
	local items3 = React.useMemo(function()
		if FFlagFriendsChatServerSideConversationSearch then
			return items
		end

		local searchText = normalizeSearchText(state) -- inferred equivalent call
		local result = {}

		for _, item in items do
			local v18 = getConversationTitle(item) or item.title or item.titleForViewer
			local previewContent = item.previewContent

			if not (searchText == "" or string.find(string.lower(v18 or ""), searchText, 1, true) ~= nil or searchText == "" or string.find(
				string.lower(previewContent or ""),
				searchText,
				1,
				true
			) ~= nil) then
				continue
			end

			table.insert(result, item)
		end

		return result
	end, { items, state })
	local v18

	if FFlagFriendsChatServerSideConversationSearch then
		local v19

		if FFlagAppChatSearchSendPlacement then
			v19 = ChatPlacementContext.Enum.InExperienceFriendsTab
		end

		v18 = useConversationSearch(state, visible, v19)

		if FFlagAppChatSearchSessionTelemetry then
			useChatSearchResultsTelemetry(v18)
		end
	end

	if v18 == nil or not v18.isActive then
		v18 = nil
	end

	if FFlagFriendsChatServerSideConversationSearch then
		items3 = items
	end

	local listState = resolveListState({
		items = items3,
		totalCount = #items,
		isFetching = listStatus.isFetchingConversations == true,
		hasError = listStatus.error ~= nil,
		hasFetchedInitialPage = listStatus.hasFetchedInitialPage == true,
		isFetchingNextPage = listStatus.isFetchingNextPage == true,
		oldestConversationIsFetched = listStatus.oldestConversationIsFetched == true or listStatus.isExhausted == true,
		loadNext = v17.loadNext
	}, v18)

	local items2 = listState.items
	local shouldOfferRetry = listState.shouldOfferRetry
	local v19 = state ~= ""
	local isFiltered

	if FFlagFriendsChatServerSideConversationSearch then
		isFiltered = v18 ~= nil
	else
		isFiltered = v19
	end

	local emptyStateType

	if FFlagFriendsChatLandingTelemetryFields then
		emptyStateType = getLandingEmptyStateType(listState, v19)
	end

	if FFlagAppChatSearchSessionTelemetry then
		useChatSearchSession(isFiltered and props.visible ~= false, FFlagFriendsChatServerSideConversationSearch)
	end

	local v20 = useFriendsChatLandingTelemetry({
		conversations = items,
		displayedConversations = items2,
		isFiltered = isFiltered,
		emptyStateType = emptyStateType
	})

	local v21 = {
		searchPlaceholder = v9.SearchPlaceholder,
		loadingConversations = v9.Loading,
		loadConversationsError = v9.SomethingWentWrong,
		noLoadedConversationsFound = v9.NoChatFound,
		noFriends = v9.NoFriends
	}
	local text

	if listState.isInitialLoading then
		text = v21.loadingConversations
	elseif listState.shouldShowBlockingError then
		text = v21.loadConversationsError
	elseif listState.shouldShowEmptyState then
		if listState.hasNoFriends then
			text = v21.noFriends
		else
			text = v21.noLoadedConversationsFound
		end
	end

	local onActivated = React.useCallback(function(p)
		if props.onConversationActivated == nil or p == nil or p.id == nil then
			return
		end

		if FFlagFriendsChatServerSideConversationSearch then
			searchIntroducedConversationIds.remove(p.id)
		end

		props.onConversationActivated(p.id)
	end, { props.onConversationActivated })

	local v22 = useChatWindowReport(props.onAbsoluteSizeChanged)
	local v23 = useChatWindowReport(props.onAbsolutePositionChanged)

	local v24 = React.useCallback(function()
		v20.fireSearchActivatedEvent()
		getTransparencyStore(false).setTextboxFocus()
	end, { getTransparencyStore, v20.fireSearchActivatedEvent })

	local v25 = React.useCallback(function()
		getTransparencyStore(false).clearTextboxFocus()
	end, { getTransparencyStore })

	React.useEffect(function()
		return function()
			getTransparencyStore(false).clearTextboxFocus()
		end
	end, { getTransparencyStore })
	local scrollBarImageTransparency, v26

	if v then
		local ref2 = React.useRef(nil)
		local v27
		scrollBarImageTransparency, v27 = ReactOtter.useAnimatedBinding(1)

		v26 = React.useCallback(function()
			if ref2.current ~= nil then
				pcall(task.cancel, ref2.current)
				ref2.current = nil
			end

			v27(ReactOtter.instant(0))

			ref2.current = task.delay(v2, function()
				ref2.current = nil
				v27((ReactOtter.spring(1, v3)))
			end)
		end, { v27 })

		React.useEffect(function()
			return function()
				if ref2.current ~= nil then
					pcall(task.cancel, ref2.current)
					ref2.current = nil
				end
			end
		end, {})
	else
		v26 = nil
	end

	local useCallback = React.useCallback
	local function fn(_)
		if v then
			v26()
		end

		getTransparencyStore(false).resetAllTransparency()
	end

	local v27

	if v then
		v27 = v26
	end

	local v28 = useCallback(fn, { getTransparencyStore, v27 })
	local id

	if FFlagFriendsChatConversationListFocusNav and items2[1] ~= nil then
		id = tostring(items2[1].id)
	else
		id = nil
	end

	local renderItem = React.useCallback(function(p)
		local id2 = tostring(p.item.id)
		local createElement = React.createElement
		local v29 = {
			conversationId = id2,
			entryHeight = conversationRowHeight,
			isWideMode = false,
			onActivated = onActivated,
			fireClickEvent = v20.fireConversationClickedEvent,
			fireImpressionEvent = v20.fireConversationImpressionEvent,
			showBackground = false,
			localUserId = props.localUserId,
			ref = 0
		}
		local ref2

		if FFlagFriendsChatConversationListFocusNav and id2 == id then
			ref2 = v15
		end

		v29.ref = ref2
		return createElement(ConversationRow, v29)
	end, {
		conversationRowHeight,
		v20.fireConversationClickedEvent,
		v20.fireConversationImpressionEvent,
		onActivated,
		props.localUserId,
		id,
		v15
	})

	local getItemLayout = React.useCallback(function(_, p: number)
		return {
			length = conversationRowHeight,
			offset = conversationRowHeight * (p - 1),
			index = p
		}
	end, { conversationRowHeight })

	local loadNext = React.useCallback(function()
		listState.loadNext()
	end, { listState.loadNext })

	local onContentSizeChange = React.useCallback(function(_: number, p: number)
		local current = ref.current

		if current ~= nil and p <= current.AbsoluteSize.Y then
			loadNext()
		end
	end, { loadNext })

	local onEndReached = React.useCallback(function()
		loadNext()
		return Promise.resolve()
	end, { loadNext })

	local v29 = React.useCallback(function(p)
		setState(p.Text)
	end, {})

	local onActivated2 = React.useCallback(function()
		setState("")
	end, {})

	local isLoadingNextPage = listState.isLoadingNextPage
	local oldestConversationIsFetched = listState.oldestConversationIsFetched
	local listKey

	if FFlagFriendsChatServerSideConversationSearch then
		listKey = listState.listKey
	end

	local list

	if FFlagFriendsChatUseViewRecyclerConversationList then
		list = React.createElement(ConversationListViewRecycler, {
			key = listKey,
			Size = UDim2.fromScale(1, 1),
			entryHeight = conversationRowHeight,
			itemList = items2,
			loadNext = loadNext,
			isLoadingNext = isLoadingNextPage,
			oldestConversationIsFetched = oldestConversationIsFetched,
			isWideMode = false,
			showScrollbarOnScroll = true,
			scrollbarThickness = defineFastInt5,
			onScrollUpdate = v28,
			rowProps = { showBackground = false, localUserId = props.localUserId },
			localUserId = props.localUserId,
			showHeaderEntries = false,
			shouldLogHeaderEntryExposures = false,
			shouldLogPerfExposure = false,
			onActivated = onActivated,
			fireConversationClickedEvent = v20.fireConversationClickedEvent,
			fireConversationImpressionEvent = v20.fireConversationImpressionEvent
		})
	else
		local createElement = React.createElement
		local v30 = {
			key = listKey,
			data = items2,
			renderItem = renderItem,
			getItemLayout = getItemLayout,
			keyExtractor = function(p)
				return (tostring(p.id))
			end,
			compareItemData = function(p, p2): boolean
				return p.id == p2.id
			end,
			style = 0,
			contentContainerStyle = 0,
			windowSize = 0,
			initialNumToRender = 0,
			onScroll = 0,
			onContentSizeChange = 0,
			onEndReached = 0,
			onEndReachedThreshold = 0,
			AutomaticCanvasSize = 0,
			CanvasSize = 0,
			autoscrollToTopThreshold = 0,
			enableAutoscrollToTop = true
		}

		if not v then
			scrollBarImageTransparency = nil
		end

		v30.style = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarImageTransparency = scrollBarImageTransparency,
			ScrollBarThickness = defineFastInt5,
			Selectable = false
		}

		v30.contentContainerStyle = { BackgroundTransparency = 1, BorderSizePixel = 0 }

		v30.windowSize = defineFastInt6
		v30.initialNumToRender = defineFastInt2
		v30.onScroll = v28
		v30.onContentSizeChange = onContentSizeChange
		v30.onEndReached = onEndReached
		v30.onEndReachedThreshold = conversationRowHeight * defineFastInt3
		v30.AutomaticCanvasSize = Enum.AutomaticSize.XY
		v30.CanvasSize = UDim2.fromScale(0, 0)
		v30.autoscrollToTopThreshold = defineFastInt
		list = createElement(BidirectionalFlatList, v30)
	end

	local createElement = React.createElement
	transparencyValue = getTransparencyOrBindingValue(backgroundTransparency, transparencyValue) -- inferred equivalent call
	local v30 = {
		Name = "chatWindow",
		Active = true,
		BackgroundColor3 = backgroundColor3,
		BackgroundTransparency = transparencyValue,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = props.LayoutOrder or 1,
		Size = props.size or UDim2.new(
			1,
			0,
			1,
			LayoutConstants.PanelTopSpacerHeight + v14 + LayoutConstants.PanelBottomCornerRadius
		),
		Visible = visible,
		ref = ref3,
		[React.Change.AbsoluteSize] = v22,
		[React.Change.AbsolutePosition] = v23,
		[React.Event.MouseEnter] = props.onHovered,
		[React.Event.MouseLeave] = props.onUnhovered
	}
	local children = {
		bottomCorner = React.createElement("UICorner", {
			BottomLeftRadius = UDim.new(0, LayoutConstants.PanelBottomCornerRadius),
			BottomRightRadius = UDim.new(0, LayoutConstants.PanelBottomCornerRadius),
			TopLeftRadius = UDim.new(0, 0),
			TopRightRadius = UDim.new(0, 0)
		}),
		layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 0),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SearchContainer = 0,
		ListArea = 0
	}

	local createElement2 = React.createElement
	local v31 = {
		Name = "SearchContainer",
		tag = "padding-small",
		BorderSizePixel = 0,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, size_1200)
	}

	local createElement3 = React.createElement
	local v32 = {
		Name = "SearchContent",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(-1, -1),
		Size = UDim2.new(1, 2, 1, 2)
	}

	local createElement4 = React.createElement
	local v58 = {
		Name = "SearchField",
		tag = "row align-y-center items-center gap-small padding-x-medium radius-circle clip",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(1, 1),
		Size = UDim2.new(1, -2, 0, v5.Size.Size_800),
		stroke = {
			Color = v5.Color.Stroke.Default.Color3,
			Transparency = transparency2,
			Thickness = v5.Stroke.Standard
		}
	}

	local v59 = {
		SearchIcon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = IconName.MagnifyingGlass,
			size = IconSize.Small,
			style = getColorStyle(v5.Color.Content.Default.Color3, transparency) -- inferred equivalent call
		}),
		SearchBox = React.createElement("TextBox", {
			Name = "FriendsChatConversationListSearchBox",
			BackgroundTransparency = 1,
			SelectionImageObject = selectionImageObject,
			ClearTextOnFocus = false,
			ClipsDescendants = true,
			FontFace = normalizeFontFace(v5.Typography.BodySmall.Font),
			LineHeight = v5.Typography.BodySmall.LineHeight,
			LayoutOrder = 2,
			PlaceholderColor3 = v5.Color.Content.Muted.Color3,
			PlaceholderText = v21.searchPlaceholder,
			Size = UDim2.new(0, 0, 1, 0),
			Text = state,
			TextColor3 = v5.Color.Content.Emphasis.Color3,
			TextSize = v5.Typography.BodySmall.FontSize,
			TextTransparency = textTransparency2,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			[React.Event.Focused] = v24,
			[React.Event.FocusLost] = v25,
			[React.Change.Text] = v29
		}, {
			Flex = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
		}),
		ClearButton = 0
	}
	local clearButton

	if v19 then
		clearButton = React.createElement(
			View,
			{
				Name = "FriendsChatConversationListSearchClear",
				LayoutOrder = 3,
				tag = "auto-xy",
				onActivated = onActivated2
			},
			{
				Icon = React.createElement(Icon, {
					name = IconName.CircleX,
					size = IconSize.Small,
					style = getColorStyle(v5.Color.Content.Default.Color3, transparency) -- inferred equivalent call
				})
			}
		)
	end

	v59.ClearButton = clearButton
	children.SearchContainer = createElement2(View, v31, {
		SearchContent = createElement3("Frame", v32, {
			SearchField = createElement4(View, v58, v59)
		})
	})

	local createElement5 = React.createElement
	local v62 = {
		Name = "ListArea",
		BorderSizePixel = 0,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 1, -size_1200)
	}

	local createElement6 = React.createElement
	local v65 = {
		Name = "ListContent",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		GroupTransparency = groupTransparency,
		Size = UDim2.fromScale(1, 1)
	}
	local v66 = {
		ListWrapper = React.createElement("Frame", {
			Name = "FriendsChatConversationListWrapper",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 1),
			ref = ref
		}, { List = list }),
		Status = 0
	}
	local status

	if text ~= nil then
		status = React.createElement(
				View,
				{
					tag = "col align-x-center align-y-center gap-small size-full padding-large",
					BorderSizePixel = 0,
					LayoutOrder = 2
				},
				{
					Message = React.createElement(Text, {
						tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default",
						Text = text,
						textStyle = getColorStyle( -- inferred equivalent call
							v5.Color.Content.Default.Color3,
							getTextTransparency(textTransparency, v5.Color.Content.Default.Transparency) -- inferred equivalent call
						)
					}),
					Retry = shouldOfferRetry and React.createElement(IconButton, {
						icon = IconName.ArrowSpinClockwise,
						onActivated = v17.retryInitialFetch,
						size = InputSize.Small,
						variant = ButtonVariant.Standard
					}) or nil
				}
			)
			or nil
	end

	v66.Status = status
	children.ListArea = createElement5(View, v62, {
		ListContent = createElement6("CanvasGroup", v65, v66)
	})
	return (createElement("Frame", v30, children))
end

return React.memo(FriendsChatConversationList)
