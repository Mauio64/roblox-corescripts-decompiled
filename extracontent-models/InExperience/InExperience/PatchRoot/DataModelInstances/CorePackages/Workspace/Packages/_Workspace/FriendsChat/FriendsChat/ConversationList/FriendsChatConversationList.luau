local TextChatService = game:GetService("TextChatService")
local FriendsChat = script:FindFirstAncestor("FriendsChat")
local FriendsChatParent = FriendsChat.Parent
local React = require(FriendsChatParent.React)
local ReactIs = require(FriendsChatParent.ReactIs)
local Foundation = require(FriendsChatParent.Foundation)
local useLocalization = require(FriendsChatParent.Localization).Hooks.useLocalization
local AppChat = require(FriendsChatParent.AppChat)
local useChatPlatform = require(FriendsChatParent.ExpChatIntegration.useChatPlatform)
local useChatInputBarSettings = require(FriendsChatParent.ExpChatIntegration.useChatInputBarSettings)
local useInterpolatedClientSettings = require(FriendsChatParent.ExpChatIntegration.useInterpolatedClientSettings)
local useChatWindowSettings = require(FriendsChatParent.ExpChatIntegration.useChatWindowSettings)
local ExpChatConversationListAdapter = require(script.Parent.ExpChatConversationListAdapter)
local useConversationListPagination = require(script.Parent.useConversationListPagination)
local LayoutConstants = require(FriendsChat.LayoutConstants)
local FFlagFriendsChatConversationListShowScrollBar = require(FriendsChatParent.SharedFlags).FFlagFriendsChatConversationListShowScrollBar
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
local getConversationTitle = ExpChatConversationListAdapter.getConversationTitle
local useConversationList = AppChat.Hooks.useConversationList
local t1 = {
	NoFriends = "Feature.Chat.Text.NoFriends",
	SearchPlaceholder = "CommonUI.Controls.Action.Search",
	Retry = "InGame.CommonUI.Button.Retry"
}

local function getColorStyle(p1, p2) -- line: 63
	return {
		Color3 = p1,
		Transparency = p2
	}
end
local function getTransparencyOrBindingValue(n1: number, p3) -- line: 70
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p3) then
		return p3:map(function(n2: number) -- line: 72
			-- upvalues: n1 (copy)
			return n1 + n2 * (1 - n1)
		end)
	end

	return p3
end
local function getTextTransparency(p4, n3: number) -- line: 80
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p4) then
		return p4:map(function(n4: number) -- line: 82
			-- upvalues: n3 (copy)
			return n3 + n4 * (1 - n3)
		end)
	end

	return n3
end
local function mergeTransparency(n5: number, t2: {[any]: any}) -- line: 90
	-- upvalues: ReactIs (copy), React (copy)
	local t3 = {}
	local u49 = n5

	for _, v51 in t2 do
		if ReactIs.isBinding(v51) then
			table.insert(t3, v51)
		else
			u49 += (v51 or 0) * (1 - u49)
		end
	end

	if #t3 == 0 then
		return u49
	end

	return React.joinBindings(t3):map(function(p5) -- line: 106
		-- upvalues: u49 (ref)
		local v135 = u49

		for _, v137 in p5 do
			v135 += v137 * (1 - v135)
		end

		return v135
	end)
end
local function normalizeSearchText(s1: string?) -- line: 115
	return string.lower(s1 or "")
end
local function containsSearchText(s2: string?, s3: string) -- line: 119
	if s3 == "" then
		return true
	end

	return string.find(string.lower(s2 or ""), s3, 1, true) ~= nil
end
local function getLocalizedText(s4: string?, s5: string, s6: string) -- line: 126
	if s4 ~= nil and (s4 ~= "" and s4 ~= s5) then
		return s4
	end

	return s6
end
local function FriendsChatConversationList(t4: {[any]: any}) -- line: 134
	-- upvalues: useTokens (copy), useChatPlatform (copy), useChatWindowSettings (copy), React (copy), useLocalization (copy), t1 (copy), useInterpolatedClientSettings (copy), ReactIs (copy), mergeTransparency (copy), useChatInputBarSettings (copy), LayoutConstants (copy), useConversationList (copy), useConversationListPagination (copy), getConversationTitle (copy), useFriendsChatLandingTelemetry (copy), TextChatService (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), ConversationListUltimate (copy), FFlagFriendsChatConversationListShowScrollBar (copy), FoundationText (copy), Button (copy), FillBehavior (copy), InputSize (copy), ButtonVariant (copy)
	local v59 = useTokens()
	local getTransparencyStore = useChatPlatform().getTransparencyStore
	local v61 = useChatWindowSettings()
	local v62 = React.useMemo(function() -- line: 138
		-- upvalues: v61 (copy)
		return {
			BackgroundColor3 = v61.ChatWindowBackgroundColor3,
			BackgroundTransparency = v61.ChatWindowBackgroundTransparency
		}
	end, { v61 })
	local v63 = t4.chatWindowSettings or v62
	local v64 = useLocalization(t1)
	local v65 = useInterpolatedClientSettings(v63)
	local BackgroundTransparency = v65.BackgroundTransparency
	local v67 = v65.BackgroundColor3 or (v65.BackgroundColor or v63.BackgroundColor3)
	local v68 = t4.transparencyValue or v61.ChatWindowBackgroundTransparency
	local g131 = nil
	local v130 = nil
	local n6

	if t4.transparencyValue == nil then
		n6 = 0
	elseif ReactIs.isBinding(v68) then
		local n7 = 0

		n6 = v68:map(function(n8: number) -- line: 72
			-- upvalues: n7 (copy)
			return n7 + n8 * (1 - n7)
		end)
	else
		n6 = v68
	end

	local v71 = t4.textTransparency or React.createBinding(0)
	local v72 = mergeTransparency(v59.Color.Content.Default.Transparency, {
		v71,
		n6
	})
	local v73 = mergeTransparency(v59.Color.Content.Emphasis.Transparency, {
		v71,
		n6
	})
	local v74 = mergeTransparency(v59.Color.Stroke.Default.Transparency, { n6 })
	local Size_1200 = v59.Size.Size_1200
	local Size_1400 = v59.Size.Size_1400
	local v77 = useChatInputBarSettings()
	local v78 = ((if not t4.isSpatialUIEnabled or (not v77 or not v77.SpatialPanelTextSize) then (if not v77 then v59.Typography.CaptionMedium.FontSize else v77.TextSize) else v77.SpatialPanelTextSize)) or v59.Typography.CaptionMedium.FontSize
	local v79 = LayoutConstants.InputBarTopPadding + LayoutConstants.InputBarBottomPadding + LayoutConstants.InputBarTextVerticalPadding + v78
	local v80, v81 = React.useState("")
	local v82 = t4.visible ~= false
	local v83 = useConversationList(v82)
	local v84 = useConversationListPagination(v82, v83.listStatus)
	local listStatus = v83.listStatus
	local items = v83.items
	local v87 = React.useMemo(function() -- line: 184
		-- upvalues: v80 (copy), items (copy), getConversationTitle (copy)
		local v139 = v80
		local v140 = string.lower(v139 or "")
		local t5 = {}

		for _, v143 in items do
			local v144 = getConversationTitle(v143) or (v143.title or v143.titleForViewer)
			local previewContent = v143.previewContent

			if v140 == "" or string.find(string.lower(v144 or ""), v140, 1, true) ~= nil or (v140 == "" or string.find(string.lower(previewContent or ""), v140, 1, true) ~= nil) then
				table.insert(t5, v143)
			end
		end

		return t5
	end, {
		items,
		v80
	})
	local v88 = #items == 0
	local v89 = listStatus.isFetchingConversations == true and v88
	local v90 = listStatus.error ~= nil
	local v91 = v80 ~= ""
	local v92 = useFriendsChatLandingTelemetry({
		conversations = items,
		displayedConversations = v87,
		isFiltered = v91
	})
	local v93 = v90 and v88
	local v94 = #v87 == 0 and (listStatus.isFetchingConversations ~= true and (not v88 or (listStatus.hasFetchedInitialPage == true or v93)))
	local t6 = {
		loadingConversations = "Loading conversations...",
		loadConversationsError = "Unable to load conversations.",
		noLoadedConversationsFound = "No loaded conversations found"
	}
	local SearchPlaceholder = v64.SearchPlaceholder
	local SearchPlaceholder2 = t1.SearchPlaceholder

	t6.searchPlaceholder = (SearchPlaceholder == nil or (SearchPlaceholder == "" or SearchPlaceholder == SearchPlaceholder2)) and "Search" or SearchPlaceholder

	local NoFriends = v64.NoFriends
	local NoFriends2 = t1.NoFriends

	t6.noFriends = (NoFriends == nil or (NoFriends == "" or NoFriends == NoFriends2)) and "Add friends to start chatting." or NoFriends

	local Retry = v64.Retry
	local Retry2 = t1.Retry

	t6.retry = (Retry == nil or (Retry == "" or Retry == Retry2)) and "Retry" or Retry

	local v102 = if not v89 then if not v93 then if not v94 then nil else if not v88 then t6.noLoadedConversationsFound else t6.noFriends else t6.loadConversationsError else t6.loadingConversations
	local v103 = React.useCallback(function(p6) -- line: 242
		-- upvalues: t4 (copy)
		if t4.onConversationActivated == nil or (p6 == nil or p6.id == nil) then
			return
		end

		t4.onConversationActivated(p6.id)
	end, { t4.onConversationActivated })
	local v104 = React.useCallback(function(p7) -- line: 250
		-- upvalues: TextChatService (copy), t4 (copy)
		local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

		if ChatWindowConfiguration and t4.onAbsoluteSizeChanged then
			t4.onAbsoluteSizeChanged(p7, ChatWindowConfiguration)
		end
	end, { t4.onAbsoluteSizeChanged })
	local v105 = React.useCallback(function(p8) -- line: 257
		-- upvalues: TextChatService (copy), t4 (copy)
		local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

		if ChatWindowConfiguration and t4.onAbsolutePositionChanged then
			t4.onAbsolutePositionChanged(p8, ChatWindowConfiguration)
		end
	end, { t4.onAbsolutePositionChanged })
	local v106 = React.useCallback(function() -- line: 264
		-- upvalues: v92 (copy), getTransparencyStore (copy)
		v92.fireSearchActivatedEvent()
		getTransparencyStore(false).setTextboxFocus()
	end, {
		getTransparencyStore,
		v92.fireSearchActivatedEvent
	})
	local v107 = React.useCallback(function() -- line: 269
		-- upvalues: getTransparencyStore (copy)
		getTransparencyStore(false).clearTextboxFocus()
	end, { getTransparencyStore })

	React.useEffect(function() -- line: 273
		-- upvalues: getTransparencyStore (copy)
		return function() -- line: 274
			-- upvalues: getTransparencyStore (copy)
			getTransparencyStore(false).clearTextboxFocus()
		end
	end, { getTransparencyStore })

	local v108 = React.useCallback(function(_) -- line: 279
		-- upvalues: getTransparencyStore (copy)
		getTransparencyStore(false).resetAllTransparency()
	end, { getTransparencyStore })
	local v109 = React.useCallback(function(p10) -- line: 283
		-- upvalues: v81 (copy)
		v81(p10.Text)
	end, {})
	local createElement = React.createElement
	local t7 = {
		Name = "chatWindow",
		Active = true,
		BackgroundColor3 = v67,
		BackgroundTransparency = if not ReactIs.isBinding(v68) then v68 else v68:map(function(n9: number) -- line: 72
			-- upvalues: BackgroundTransparency (copy)
			return BackgroundTransparency + n9 * (1 - BackgroundTransparency)
		end),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = t4.LayoutOrder or 1,
		Size = t4.size or UDim2.new(1, 0, 1, LayoutConstants.PanelTopSpacerHeight + v79 + LayoutConstants.PanelBottomCornerRadius),
		Visible = v82,
		[React.Change.AbsoluteSize] = v104,
		[React.Change.AbsolutePosition] = v105,
		[React.Event.MouseEnter] = t4.onHovered,
		[React.Event.MouseLeave] = t4.onUnhovered
	}
	local t8 = {
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
					tag = "row align-y-center items-center gap-small padding-x-medium radius-circle",
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(1, 1),
					Size = UDim2.new(1, -2, 0, v59.Size.Size_800),
					stroke = {
						Color = v59.Color.Stroke.Default.Color3,
						Transparency = v74,
						Thickness = v59.Stroke.Standard
					}
				}, {
					SearchIcon = React.createElement(Icon, {
						LayoutOrder = 1,
						name = IconName.MagnifyingGlass,
						size = IconSize.Small,
						style = {
							Color3 = v59.Color.Content.Default.Color3,
							Transparency = v72
						}
					}),
					SearchBox = React.createElement("TextBox", {
						Name = "FriendsChatConversationListSearchBox",
						BackgroundTransparency = 1,
						ClearTextOnFocus = false,
						Font = v59.Typography.BodySmall.Font,
						LineHeight = v59.Typography.BodySmall.LineHeight,
						LayoutOrder = 2,
						PlaceholderColor3 = v59.Color.Content.Muted.Color3,
						PlaceholderText = t6.searchPlaceholder,
						Size = UDim2.new(0, 0, 1, 0),
						Text = v80,
						TextColor3 = v59.Color.Content.Emphasis.Color3,
						TextSize = v59.Typography.BodySmall.FontSize,
						TextTransparency = v73,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						[React.Event.Focused] = v106,
						[React.Event.FocusLost] = v107,
						[React.Change.Text] = v109
					}, {
						Flex = React.createElement("UIFlexItem", {
							FlexMode = Enum.UIFlexMode.Fill
						})
					})
				})
			})
		})
	}
	local createElement2 = React.createElement
	local v114 = View
	local t9 = {
		Name = "ListArea",
		BorderSizePixel = 0,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 1, -Size_1200)
	}
	local t10 = {}
	local createElement3 = React.createElement
	local t11 = {
		Name = "ListContent",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		GroupTransparency = n6,
		Size = UDim2.fromScale(1, 1)
	}
	local t12 = {
		ListWrapper = React.createElement("Frame", {
			Name = "FriendsChatConversationListWrapper",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			List = React.createElement(ConversationListUltimate, {
				isWideMode = false,
				showHeaderEntries = false,
				shouldLogHeaderEntryExposures = false,
				Size = UDim2.fromScale(1, 1),
				entryHeight = Size_1400,
				itemList = v87,
				loadNext = v84.loadNext,
				isLoadingNext = listStatus.isFetchingNextPage == true,
				oldestConversationIsFetched = listStatus.oldestConversationIsFetched == true or listStatus.isExhausted == true,
				showScrollbarOnScroll = not not FFlagFriendsChatConversationListShowScrollBar or nil,
				onScrollUpdate = v108,
				rowProps = {
					showBackground = false,
					localUserId = t4.localUserId
				},
				localUserId = t4.localUserId,
				onActivated = v103,
				fireConversationClickedEvent = v92.fireConversationClickedEvent,
				fireConversationImpressionEvent = v92.fireConversationImpressionEvent
			})
		})
	}

	if v102 ~= nil then
		local createElement4 = React.createElement
		local v121 = View
		local t13 = {
			tag = "col align-x-center align-y-center gap-small size-full padding-large",
			BorderSizePixel = 0,
			LayoutOrder = 2
		}
		local t14 = {}
		local createElement5 = React.createElement
		local v125 = FoundationText
		local t15 = {
			tag = "size-full-0 auto-y text-wrap text-body-medium text-align-x-center content-default",
			Text = v102
		}
		local DefaultColor3 = v59.Color.Content.Default.Color3
		local DefaultTransparency = v59.Color.Content.Default.Transparency
		local v129 = if not ReactIs.isBinding(v71) then DefaultTransparency else v71:map(function(n10: number) -- line: 82
			-- upvalues: DefaultTransparency (copy)
			return DefaultTransparency + n10 * (1 - DefaultTransparency)
		end)

		t15.textStyle = {
			Color3 = DefaultColor3,
			Transparency = v129
		}
		t14.Message = createElement5(v125, t15)
		t14.Retry = v93 and React.createElement(Button, {
			fillBehavior = FillBehavior.Fit,
			onActivated = v84.retryInitialFetch,
			size = InputSize.Small,
			text = t6.retry,
			variant = ButtonVariant.Standard
		}) or nil
		v130 = createElement4(v121, t13, t14)

		if v130 then
			g131 = true
		end
	end

	if not g131 then
		v130 = nil
	end

	g131 = false
	t12.Status = v130
	t10.ListContent = createElement3("CanvasGroup", t11, t12)
	t8.ListArea = createElement2(v114, t9, t10)

	return (createElement("Frame", t7, t8))
end

return React.memo(FriendsChatConversationList)
