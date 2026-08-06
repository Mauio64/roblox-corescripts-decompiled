local TextChatService = game:GetService("TextChatService")
local FriendsChat = script:FindFirstAncestor("FriendsChat")
local FriendsChatParent = FriendsChat.Parent
local React = require(FriendsChatParent.React)
local ReactIs = require(FriendsChatParent.ReactIs)
local Foundation = require(FriendsChatParent.Foundation)
local Localization = require(FriendsChatParent.Localization)
local Promise = require(FriendsChatParent.Promise)
local useLocalization = Localization.Hooks.useLocalization
local AppChat = require(FriendsChatParent.AppChat)
local FFlagAppChatUseUltimateListConversationList = require(FriendsChatParent.AppChat.FFlagAppChatUseUltimateListConversationList)
local BidirectionalFlatList = require(FriendsChatParent.VirtualizedList).BidirectionalFlatList
local useChatPlatform = require(FriendsChatParent.ExpChatIntegration.useChatPlatform)
local useChatInputBarSettings = require(FriendsChatParent.ExpChatIntegration.useChatInputBarSettings)
local useInterpolatedClientSettings = require(FriendsChatParent.ExpChatIntegration.useInterpolatedClientSettings)
local useChatWindowSettings = require(FriendsChatParent.ExpChatIntegration.useChatWindowSettings)
local ExpChatConversationListAdapter = require(script.Parent.ExpChatConversationListAdapter)
local useConversationListPagination = require(script.Parent.useConversationListPagination)
local LayoutConstants = require(FriendsChat.LayoutConstants)
local useFriendsChatLandingTelemetry = require(script.Parent.Parent.Telemetry.ChatLanding.useFriendsChatLandingTelemetry)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local ConversationListUltimate = AppChat.Components.ChatLanding.ConversationListUltimate
local ConversationRow = AppChat.Components.ChatLanding.ConversationRow
local getConversationTitle = ExpChatConversationListAdapter.getConversationTitle
local useConversationList = AppChat.Hooks.useConversationList
local v35 = game:DefineFastInt("FriendsChatConversationListAutoscrollToTopThreshold", 33)
local v36 = game:DefineFastInt("FriendsChatConversationListInitialNumToRender", 8)
local v37 = game:DefineFastInt("FriendsChatConversationListPaginationThresholdRows", 10)
local v38 = game:DefineFastInt("FriendsChatConversationListScrollbarThickness", 8)
local v39 = game:DefineFastInt("FriendsChatConversationListWindowSize", 2)
local t1 = {
	NoFriends = "Feature.Chat.Text.NoFriends",
	SearchPlaceholder = "CommonUI.Controls.Action.Search",
	Retry = "InGame.CommonUI.Button.Retry",
	Loading = "Feature.Chat.Label.Loading",
	TryAgain = "Feature.Chat.Label.TryAgain",
	NoChatFound = "Feature.Chat.Label.NoChatFound"
}

local function getColorStyle(p1, p2) -- line: 85
	return {
		Color3 = p1,
		Transparency = p2
	}
end
local function getTransparencyOrBindingValue(n1: number, p3) -- line: 92
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p3) then
		return p3:map(function(n2: number) -- line: 94
			-- upvalues: n1 (copy)
			return n1 + n2 * (1 - n1)
		end)
	end

	return p3
end
local function getTextTransparency(p4, n3: number) -- line: 102
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p4) then
		return p4:map(function(n4: number) -- line: 104
			-- upvalues: n3 (copy)
			return n3 + n4 * (1 - n3)
		end)
	end

	return n3
end
local function mergeTransparency(n5: number, t2: {[any]: any}) -- line: 112
	-- upvalues: ReactIs (copy), React (copy)
	local t3 = {}
	local u57 = n5

	for _, v59 in t2 do
		if ReactIs.isBinding(v59) then
			table.insert(t3, v59)
		else
			u57 += (v59 or 0) * (1 - u57)
		end
	end

	if #t3 == 0 then
		return u57
	end

	return React.joinBindings(t3):map(function(p5) -- line: 128
		-- upvalues: u57 (ref)
		local v141 = u57

		for _, v143 in p5 do
			v141 += v143 * (1 - v141)
		end

		return v141
	end)
end
local function normalizeSearchText(s1: string?) -- line: 137
	return string.lower(s1 or "")
end
local function containsSearchText(s2: string?, s3: string) -- line: 141
	if s3 == "" then
		return true
	end

	return string.find(string.lower(s2 or ""), s3, 1, true) ~= nil
end
local function FriendsChatConversationList(t4: {[any]: any}) -- line: 148
	-- upvalues: useTokens (copy), useChatPlatform (copy), useChatWindowSettings (copy), React (copy), useLocalization (copy), t1 (copy), useInterpolatedClientSettings (copy), ReactIs (copy), mergeTransparency (copy), useChatInputBarSettings (copy), LayoutConstants (copy), useConversationList (copy), useConversationListPagination (copy), getConversationTitle (copy), useFriendsChatLandingTelemetry (copy), TextChatService (copy), ConversationRow (copy), Promise (copy), FFlagAppChatUseUltimateListConversationList (copy), ConversationListUltimate (copy), BidirectionalFlatList (copy), v38 (copy), v39 (copy), v36 (copy), v37 (copy), v35 (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), FoundationText (copy), Button (copy), FillBehavior (copy), InputSize (copy), ButtonVariant (copy)
	local v64 = useTokens()
	local getTransparencyStore = useChatPlatform().getTransparencyStore
	local v66 = useChatWindowSettings()
	local v67 = React.useMemo(function() -- line: 152
		-- upvalues: v66 (copy)
		return {
			BackgroundColor3 = v66.ChatWindowBackgroundColor3,
			BackgroundTransparency = v66.ChatWindowBackgroundTransparency
		}
	end, { v66 })
	local v68 = t4.chatWindowSettings or v67
	local v69 = useLocalization(t1)
	local v70 = useInterpolatedClientSettings(v68)
	local BackgroundTransparency = v70.BackgroundTransparency
	local v72 = v70.BackgroundColor3 or (v70.BackgroundColor or v68.BackgroundColor3)
	local v73 = t4.transparencyValue or v66.ChatWindowBackgroundTransparency
	local g137 = nil
	local v136 = nil
	local n6

	if t4.transparencyValue == nil then
		n6 = 0
	elseif ReactIs.isBinding(v73) then
		local n7 = 0

		n6 = v73:map(function(n8: number) -- line: 94
			-- upvalues: n7 (copy)
			return n7 + n8 * (1 - n7)
		end)
	else
		n6 = v73
	end

	local v76 = t4.textTransparency or React.createBinding(0)
	local v77 = mergeTransparency(v64.Color.Content.Default.Transparency, {
		v76,
		n6
	})
	local v78 = mergeTransparency(v64.Color.Content.Emphasis.Transparency, {
		v76,
		n6
	})
	local v79 = mergeTransparency(v64.Color.Stroke.Default.Transparency, { n6 })
	local Size_1200 = v64.Size.Size_1200
	local Size_1400 = v64.Size.Size_1400
	local v82 = useChatInputBarSettings()
	local v83 = ((if not t4.isSpatialUIEnabled or (not v82 or not v82.SpatialPanelTextSize) then (if not v82 then v64.Typography.CaptionMedium.FontSize else v82.TextSize) else v82.SpatialPanelTextSize)) or v64.Typography.CaptionMedium.FontSize
	local v84 = LayoutConstants.InputBarTopPadding + LayoutConstants.InputBarBottomPadding + LayoutConstants.InputBarTextVerticalPadding + v83
	local v85, v86 = React.useState("")
	local v87 = React.useRef(nil)
	local v88 = t4.visible ~= false
	local v89 = useConversationList(v88)
	local v90 = useConversationListPagination(v88, v89.listStatus)
	local listStatus = v89.listStatus
	local items = v89.items
	local v93 = React.useMemo(function() -- line: 199
		-- upvalues: v85 (copy), items (copy), getConversationTitle (copy)
		local v145 = v85
		local v146 = string.lower(v145 or "")
		local t5 = {}

		for _, v149 in items do
			local v150 = getConversationTitle(v149) or (v149.title or v149.titleForViewer)
			local previewContent = v149.previewContent

			if v146 == "" or string.find(string.lower(v150 or ""), v146, 1, true) ~= nil or (v146 == "" or string.find(string.lower(previewContent or ""), v146, 1, true) ~= nil) then
				table.insert(t5, v149)
			end
		end

		return t5
	end, {
		items,
		v85
	})
	local v94 = #items == 0
	local v95 = listStatus.isFetchingConversations == true and v94
	local v96 = listStatus.error ~= nil
	local v97 = v85 ~= ""
	local v98 = useFriendsChatLandingTelemetry({
		conversations = items,
		displayedConversations = v93,
		isFiltered = v97
	})
	local v99 = v96 and v94
	local v100 = #v93 == 0 and (listStatus.isFetchingConversations ~= true and (not v94 or (listStatus.hasFetchedInitialPage == true or v99)))
	local t6 = {
		searchPlaceholder = v69.SearchPlaceholder,
		loadingConversations = v69.Loading,
		loadConversationsError = v69.TryAgain,
		noLoadedConversationsFound = v69.NoChatFound,
		noFriends = v69.NoFriends,
		retry = v69.Retry
	}
	local v102 = if not v95 then if not v99 then if not v100 then nil else if not v94 then t6.noLoadedConversationsFound else t6.noFriends else t6.loadConversationsError else t6.loadingConversations
	local v103 = React.useCallback(function(p6) -- line: 248
		-- upvalues: t4 (copy)
		if t4.onConversationActivated == nil or (p6 == nil or p6.id == nil) then
			return
		end

		t4.onConversationActivated(p6.id)
	end, { t4.onConversationActivated })
	local v104 = React.useCallback(function(p7) -- line: 256
		-- upvalues: TextChatService (copy), t4 (copy)
		local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

		if ChatWindowConfiguration and t4.onAbsoluteSizeChanged then
			t4.onAbsoluteSizeChanged(p7, ChatWindowConfiguration)
		end
	end, { t4.onAbsoluteSizeChanged })
	local v105 = React.useCallback(function(p8) -- line: 263
		-- upvalues: TextChatService (copy), t4 (copy)
		local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

		if ChatWindowConfiguration and t4.onAbsolutePositionChanged then
			t4.onAbsolutePositionChanged(p8, ChatWindowConfiguration)
		end
	end, { t4.onAbsolutePositionChanged })
	local v106 = React.useCallback(function() -- line: 270
		-- upvalues: v98 (copy), getTransparencyStore (copy)
		v98.fireSearchActivatedEvent()
		getTransparencyStore(false).setTextboxFocus()
	end, {
		getTransparencyStore,
		v98.fireSearchActivatedEvent
	})
	local v107 = React.useCallback(function() -- line: 275
		-- upvalues: getTransparencyStore (copy)
		getTransparencyStore(false).clearTextboxFocus()
	end, { getTransparencyStore })

	React.useEffect(function() -- line: 279
		-- upvalues: getTransparencyStore (copy)
		return function() -- line: 280
			-- upvalues: getTransparencyStore (copy)
			getTransparencyStore(false).clearTextboxFocus()
		end
	end, { getTransparencyStore })

	local v108 = React.useCallback(function(_) -- line: 285
		-- upvalues: getTransparencyStore (copy)
		getTransparencyStore(false).resetAllTransparency()
	end, { getTransparencyStore })
	local v109 = React.useCallback(function(p10) -- line: 290
		-- upvalues: React (copy), ConversationRow (copy), Size_1400 (copy), v103 (copy), v98 (copy), t4 (copy)
		local item = p10.item

		return React.createElement(ConversationRow, {
			isWideMode = false,
			showBackground = false,
			conversationId = tostring(item.id),
			entryHeight = Size_1400,
			onActivated = v103,
			fireClickEvent = v98.fireConversationClickedEvent,
			fireImpressionEvent = v98.fireConversationImpressionEvent,
			localUserId = t4.localUserId
		})
	end, {
		Size_1400,
		v98.fireConversationClickedEvent,
		v98.fireConversationImpressionEvent,
		v103,
		t4.localUserId
	})
	local v110 = React.useCallback(function(_: {[any]: any}?, n9: number) -- line: 312
		-- upvalues: Size_1400 (copy)
		return {
			length = Size_1400,
			offset = Size_1400 * (n9 - 1),
			index = n9
		}
	end, { Size_1400 })
	local v111 = React.useCallback(function(_: number, n11: number) -- line: 320
		-- upvalues: v87 (copy), v90 (copy)
		local current = v87.current

		if current ~= nil and n11 <= current.AbsoluteSize.Y then
			v90.loadNext()
		end
	end, { v90.loadNext })
	local v112 = React.useCallback(function() -- line: 327
		-- upvalues: v90 (copy), Promise (copy)
		v90.loadNext()

		return Promise.resolve()
	end, { v90.loadNext })
	local v113 = React.useCallback(function(p11) -- line: 332
		-- upvalues: v86 (copy)
		v86(p11.Text)
	end, {})
	local v114 = React.useCallback(function() -- line: 336
		-- upvalues: v86 (copy)
		v86("")
	end, {})
	local v115 = if not FFlagAppChatUseUltimateListConversationList then React.createElement(BidirectionalFlatList, {
		enableAutoscrollToTop = true,
		data = v93,
		renderItem = v109,
		getItemLayout = v110,
		keyExtractor = function(p12) -- line: 367
			return (tostring(p12.id))
		end,
		compareItemData = function(p13, p14) -- line: 370
			return p13.id == p14.id
		end,
		style = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			ScrollBarThickness = v38
		},
		contentContainerStyle = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		windowSize = v39,
		initialNumToRender = v36,
		onScroll = v108,
		onContentSizeChange = v111,
		onEndReached = v112,
		onEndReachedThreshold = Size_1400 * v37,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		CanvasSize = UDim2.fromScale(0, 0),
		autoscrollToTopThreshold = v35
	}) else React.createElement(ConversationListUltimate, {
		isWideMode = false,
		showScrollbarOnScroll = true,
		showHeaderEntries = false,
		shouldLogHeaderEntryExposures = false,
		Size = UDim2.fromScale(1, 1),
		entryHeight = Size_1400,
		itemList = v93,
		loadNext = v90.loadNext,
		isLoadingNext = listStatus.isFetchingNextPage == true,
		oldestConversationIsFetched = listStatus.oldestConversationIsFetched == true or listStatus.isExhausted == true,
		onScrollUpdate = v108,
		rowProps = {
			showBackground = false,
			localUserId = t4.localUserId
		},
		localUserId = t4.localUserId,
		onActivated = v103,
		fireConversationClickedEvent = v98.fireConversationClickedEvent,
		fireConversationImpressionEvent = v98.fireConversationImpressionEvent
	})
	local createElement = React.createElement
	local t8 = {
		Name = "chatWindow",
		Active = true,
		BackgroundColor3 = v72,
		BackgroundTransparency = if not ReactIs.isBinding(v73) then v73 else v73:map(function(n12: number) -- line: 94
			-- upvalues: BackgroundTransparency (copy)
			return BackgroundTransparency + n12 * (1 - BackgroundTransparency)
		end),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = t4.LayoutOrder or 1,
		Size = t4.size or UDim2.new(1, 0, 1, LayoutConstants.PanelTopSpacerHeight + v84 + LayoutConstants.PanelBottomCornerRadius),
		Visible = v88,
		[React.Change.AbsoluteSize] = v104,
		[React.Change.AbsolutePosition] = v105,
		[React.Event.MouseEnter] = t4.onHovered,
		[React.Event.MouseLeave] = t4.onUnhovered
	}
	local t9 = {
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
		SearchContainer = React.createElement(View, {
			Name = "SearchContainer",
			tag = "padding-small",
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, Size_1200)
		}, {
			SearchContent = React.createElement("Frame", {
				Name = "SearchContent",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(-1, -1),
				Size = UDim2.new(1, 2, 1, 2)
			}, {
				SearchField = React.createElement(View, {
					Name = "SearchField",
					tag = "row align-y-center items-center gap-small padding-x-medium radius-circle clip",
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(1, 1),
					Size = UDim2.new(1, -2, 0, v64.Size.Size_800),
					stroke = {
						Color = v64.Color.Stroke.Default.Color3,
						Transparency = v79,
						Thickness = v64.Stroke.Standard
					}
				}, {
					SearchIcon = React.createElement(Icon, {
						LayoutOrder = 1,
						name = IconName.MagnifyingGlass,
						size = IconSize.Small,
						style = {
							Color3 = v64.Color.Content.Default.Color3,
							Transparency = v77
						}
					}),
					SearchBox = React.createElement("TextBox", {
						Name = "FriendsChatConversationListSearchBox",
						BackgroundTransparency = 1,
						ClearTextOnFocus = false,
						ClipsDescendants = true,
						Font = v64.Typography.BodySmall.Font,
						LineHeight = v64.Typography.BodySmall.LineHeight,
						LayoutOrder = 2,
						PlaceholderColor3 = v64.Color.Content.Muted.Color3,
						PlaceholderText = t6.searchPlaceholder,
						Size = UDim2.new(0, 0, 1, 0),
						Text = v85,
						TextColor3 = v64.Color.Content.Emphasis.Color3,
						TextSize = v64.Typography.BodySmall.FontSize,
						TextTransparency = v78,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						[React.Event.Focused] = v106,
						[React.Event.FocusLost] = v107,
						[React.Change.Text] = v113
					}, {
						Flex = React.createElement("UIFlexItem", {
							FlexMode = Enum.UIFlexMode.Fill
						})
					}),
					ClearButton = if not v97 then nil else React.createElement(View, {
						Name = "FriendsChatConversationListSearchClear",
						LayoutOrder = 3,
						tag = "auto-xy",
						onActivated = v114
					}, {
						Icon = React.createElement(Icon, {
							name = IconName.CircleX,
							size = IconSize.Small,
							style = {
								Color3 = v64.Color.Content.Default.Color3,
								Transparency = v77
							}
						})
					})
				})
			})
		})
	}
	local createElement2 = React.createElement
	local v120 = View
	local t10 = {
		Name = "ListArea",
		BorderSizePixel = 0,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 1, -Size_1200)
	}
	local t11 = {}
	local createElement3 = React.createElement
	local t12 = {
		Name = "ListContent",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		GroupTransparency = n6,
		Size = UDim2.fromScale(1, 1)
	}
	local t13 = {
		ListWrapper = React.createElement("Frame", {
			Name = "FriendsChatConversationListWrapper",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 1),
			ref = v87
		}, {
			List = v115
		})
	}

	if v102 ~= nil then
		local createElement4 = React.createElement
		local v127 = View
		local t14 = {
			tag = "col align-x-center align-y-center gap-small size-full padding-large",
			BorderSizePixel = 0,
			LayoutOrder = 2
		}
		local t15 = {}
		local createElement5 = React.createElement
		local v131 = FoundationText
		local t16 = {
			tag = "size-full-0 auto-y text-wrap text-body-medium text-align-x-center content-default",
			Text = v102
		}
		local DefaultColor3 = v64.Color.Content.Default.Color3
		local DefaultTransparency = v64.Color.Content.Default.Transparency
		local v135 = if not ReactIs.isBinding(v76) then DefaultTransparency else v76:map(function(n13: number) -- line: 104
			-- upvalues: DefaultTransparency (copy)
			return DefaultTransparency + n13 * (1 - DefaultTransparency)
		end)

		t16.textStyle = {
			Color3 = DefaultColor3,
			Transparency = v135
		}
		t15.Message = createElement5(v131, t16)
		t15.Retry = v99 and React.createElement(Button, {
			fillBehavior = FillBehavior.Fit,
			onActivated = v90.retryInitialFetch,
			size = InputSize.Small,
			text = t6.retry,
			variant = ButtonVariant.Standard
		}) or nil
		v136 = createElement4(v127, t14, t15)

		if v136 then
			g137 = true
		end
	end

	if not g137 then
		v136 = nil
	end

	g137 = false
	t13.Status = v136
	t11.ListContent = createElement3("CanvasGroup", t12, t13)
	t9.ListArea = createElement2(v120, t10, t11)

	return (createElement("Frame", t8, t9))
end

return React.memo(FriendsChatConversationList)
