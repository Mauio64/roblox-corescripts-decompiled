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
	SearchPlaceholder = "CommonUI.Controls.Action.Search",
	Retry = "InGame.CommonUI.Button.Retry"
}

local function getColorStyle(p1, p2) -- line: 60
	return {
		Color3 = p1,
		Transparency = p2
	}
end
local function getTransparencyOrBindingValue(n1: number, p3) -- line: 67
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p3) then
		return p3:map(function(n2: number) -- line: 69
			-- upvalues: n1 (copy)
			return n1 + n2 * (1 - n1)
		end)
	end

	return p3
end
local function getTextTransparency(p4, n3: number) -- line: 77
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p4) then
		return p4:map(function(n4: number) -- line: 79
			-- upvalues: n3 (copy)
			return n3 + n4 * (1 - n3)
		end)
	end

	return n3
end
local function normalizeSearchText(s1: string?) -- line: 87
	return string.lower(s1 or "")
end
local function containsSearchText(s2: string?, s3: string) -- line: 91
	if s3 == "" then
		return true
	end

	return string.find(string.lower(s2 or ""), s3, 1, true) ~= nil
end
local function getLocalizedText(s4: string?, s5: string, s6: string) -- line: 98
	if s4 ~= nil and (s4 ~= "" and s4 ~= s5) then
		return s4
	end

	return s6
end
local function FriendsChatConversationList(t2: {[any]: any}) -- line: 106
	-- upvalues: useTokens (copy), useChatPlatform (copy), useChatWindowSettings (copy), React (copy), useLocalization (copy), t1 (copy), useInterpolatedClientSettings (copy), ReactIs (copy), useChatInputBarSettings (copy), LayoutConstants (copy), useConversationList (copy), useConversationListPagination (copy), getConversationTitle (copy), useFriendsChatLandingTelemetry (copy), TextChatService (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), ConversationListUltimate (copy), FoundationText (copy), Button (copy), FillBehavior (copy), InputSize (copy), ButtonVariant (copy)
	local v51 = useTokens()
	local getTransparencyStore = useChatPlatform().getTransparencyStore
	local v53 = useChatWindowSettings()
	local v54 = React.useMemo(function() -- line: 110
		-- upvalues: v53 (copy)
		return {
			BackgroundColor3 = v53.ChatWindowBackgroundColor3,
			BackgroundTransparency = v53.ChatWindowBackgroundTransparency
		}
	end, { v53 })
	local v55 = t2.chatWindowSettings or v54
	local v56 = useLocalization(t1)
	local v57 = useInterpolatedClientSettings(v55)
	local BackgroundTransparency = v57.BackgroundTransparency
	local v59 = v57.BackgroundColor3 or (v57.BackgroundColor or v55.BackgroundColor3)
	local v60 = t2.transparencyValue or v53.ChatWindowBackgroundTransparency
	local g137 = nil
	local v136 = nil
	local n5

	if t2.transparencyValue == nil then
		n5 = 0
	elseif ReactIs.isBinding(v60) then
		local n6 = 0

		n5 = v60:map(function(n7: number) -- line: 69
			-- upvalues: n6 (copy)
			return n6 + n7 * (1 - n6)
		end)
	else
		n5 = v60
	end

	local v63 = t2.textTransparency or React.createBinding(0)
	local Size_1200 = v51.Size.Size_1200
	local Size_1400 = v51.Size.Size_1400
	local v66 = useChatInputBarSettings()
	local v67 = ((if not t2.isSpatialUIEnabled or (not v66 or not v66.SpatialPanelTextSize) then (if not v66 then v51.Typography.CaptionMedium.FontSize else v66.TextSize) else v66.SpatialPanelTextSize)) or v51.Typography.CaptionMedium.FontSize
	local v68 = LayoutConstants.InputBarTopPadding + LayoutConstants.InputBarBottomPadding + LayoutConstants.InputBarTextVerticalPadding + v67
	local v69, v70 = React.useState("")
	local v71 = t2.visible ~= false
	local v72 = useConversationList(v71)
	local v73 = useConversationListPagination(v71, v72.listStatus)
	local listStatus = v72.listStatus
	local items = v72.items
	local v76 = React.useMemo(function() -- line: 150
		-- upvalues: v69 (copy), items (copy), getConversationTitle (copy)
		local v141 = v69
		local v142 = string.lower(v141 or "")
		local t3 = {}

		for _, v145 in items do
			local v146 = getConversationTitle(v145) or (v145.title or v145.titleForViewer)
			local previewContent = v145.previewContent

			if v142 == "" or string.find(string.lower(v146 or ""), v142, 1, true) ~= nil or (v142 == "" or string.find(string.lower(previewContent or ""), v142, 1, true) ~= nil) then
				table.insert(t3, v145)
			end
		end

		return t3
	end, {
		items,
		v69
	})
	local v77 = listStatus.isFetchingConversations == true and #items == 0
	local v78 = listStatus.error ~= nil
	local v79 = v69 ~= ""
	local v80 = useFriendsChatLandingTelemetry({
		conversations = items,
		displayedConversations = v76,
		isFiltered = v79
	})
	local v81 = v78 and #items == 0
	local v82 = #v76 == 0 and (listStatus.isFetchingConversations ~= true and (#items > 0 or (listStatus.hasFetchedInitialPage == true or v81)))
	local t4 = {
		loadingConversations = "Loading conversations...",
		loadConversationsError = "Unable to load conversations.",
		noLoadedConversationsFound = "No loaded conversations found",
		noConversationsYet = "No conversations yet"
	}
	local SearchPlaceholder = v56.SearchPlaceholder
	local SearchPlaceholder2 = t1.SearchPlaceholder

	t4.searchPlaceholder = (SearchPlaceholder == nil or (SearchPlaceholder == "" or SearchPlaceholder == SearchPlaceholder2)) and "Search" or SearchPlaceholder

	local Retry = v56.Retry
	local Retry2 = t1.Retry

	t4.retry = (Retry == nil or (Retry == "" or Retry == Retry2)) and "Retry" or Retry

	local v88 = if not v77 then if not v81 then if not v82 then nil else if not v79 then t4.noConversationsYet else t4.noLoadedConversationsFound else t4.loadConversationsError else t4.loadingConversations
	local v89 = React.useCallback(function(p5) -- line: 203
		-- upvalues: t2 (copy)
		if t2.onConversationActivated == nil or (p5 == nil or p5.id == nil) then
			return
		end

		t2.onConversationActivated(p5.id)
	end, { t2.onConversationActivated })
	local v90 = React.useCallback(function(p6) -- line: 211
		-- upvalues: TextChatService (copy), t2 (copy)
		local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

		if ChatWindowConfiguration and t2.onAbsoluteSizeChanged then
			t2.onAbsoluteSizeChanged(p6, ChatWindowConfiguration)
		end
	end, { t2.onAbsoluteSizeChanged })
	local v91 = React.useCallback(function(p7) -- line: 218
		-- upvalues: TextChatService (copy), t2 (copy)
		local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

		if ChatWindowConfiguration and t2.onAbsolutePositionChanged then
			t2.onAbsolutePositionChanged(p7, ChatWindowConfiguration)
		end
	end, { t2.onAbsolutePositionChanged })
	local v92 = React.useCallback(function() -- line: 225
		-- upvalues: v80 (copy), getTransparencyStore (copy)
		v80.fireSearchActivatedEvent()
		getTransparencyStore(false).setTextboxFocus()
	end, {
		getTransparencyStore,
		v80.fireSearchActivatedEvent
	})
	local v93 = React.useCallback(function() -- line: 230
		-- upvalues: getTransparencyStore (copy)
		getTransparencyStore(false).clearTextboxFocus()
	end, { getTransparencyStore })

	React.useEffect(function() -- line: 234
		-- upvalues: getTransparencyStore (copy)
		return function() -- line: 235
			-- upvalues: getTransparencyStore (copy)
			getTransparencyStore(false).clearTextboxFocus()
		end
	end, { getTransparencyStore })

	local v94 = React.useCallback(function(_) -- line: 240
		-- upvalues: getTransparencyStore (copy)
		getTransparencyStore(false).resetAllTransparency()
	end, { getTransparencyStore })
	local v95 = React.useCallback(function(p9) -- line: 244
		-- upvalues: v70 (copy)
		v70(p9.Text)
	end, {})
	local createElement = React.createElement
	local t5 = {
		Name = "chatWindow",
		Active = true,
		BackgroundColor3 = v59,
		BackgroundTransparency = if not ReactIs.isBinding(v60) then v60 else v60:map(function(n8: number) -- line: 69
			-- upvalues: BackgroundTransparency (copy)
			return BackgroundTransparency + n8 * (1 - BackgroundTransparency)
		end),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = t2.LayoutOrder or 1,
		Size = t2.size or UDim2.new(1, 0, 1, LayoutConstants.PanelTopSpacerHeight + v68 + LayoutConstants.PanelBottomCornerRadius),
		Visible = v71,
		[React.Change.AbsoluteSize] = v90,
		[React.Change.AbsolutePosition] = v91,
		[React.Event.MouseEnter] = t2.onHovered,
		[React.Event.MouseLeave] = t2.onUnhovered
	}
	local t6 = {
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
		})
	}
	local createElement2 = React.createElement
	local v100 = View
	local t7 = {
		Name = "SearchContainer",
		tag = "padding-small",
		BorderSizePixel = 0,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, Size_1200)
	}
	local t8 = {}
	local createElement3 = React.createElement
	local t9 = {
		Name = "SearchContent",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		GroupTransparency = n5,
		Position = UDim2.fromOffset(-1, -1),
		Size = UDim2.new(1, 2, 1, 2)
	}
	local t10 = {}
	local createElement4 = React.createElement
	local v107 = View
	local t11 = {
		Name = "SearchField",
		tag = "row align-y-center gap-small padding-x-medium stroke-standard stroke-default radius-circle",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(1, 1),
		Size = UDim2.new(1, -2, 0, v51.Size.Size_800)
	}
	local t12 = {}
	local createElement5 = React.createElement
	local v111 = Icon
	local t13 = {
		LayoutOrder = 1,
		name = IconName.MagnifyingGlass,
		size = IconSize.Small
	}
	local DefaultColor3 = v51.Color.Content.Default.Color3
	local DefaultTransparency = v51.Color.Content.Default.Transparency
	local v115 = if not ReactIs.isBinding(v63) then DefaultTransparency else v63:map(function(n9: number) -- line: 79
		-- upvalues: DefaultTransparency (copy)
		return DefaultTransparency + n9 * (1 - DefaultTransparency)
	end)

	t13.style = {
		Color3 = DefaultColor3,
		Transparency = v115
	}
	t12.SearchIcon = createElement5(v111, t13)

	local createElement6 = React.createElement
	local t14 = {
		Name = "FriendsChatConversationListSearchBox",
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		Font = v51.Typography.BodySmall.Font,
		LineHeight = v51.Typography.BodySmall.LineHeight,
		LayoutOrder = 2,
		PlaceholderColor3 = v51.Color.Content.Muted.Color3,
		PlaceholderText = t4.searchPlaceholder,
		Size = UDim2.new(0, 0, 1, 0),
		Text = v69,
		TextColor3 = v51.Color.Content.Emphasis.Color3,
		TextSize = v51.Typography.BodySmall.FontSize
	}
	local EmphasisTransparency = v51.Color.Content.Emphasis.Transparency

	t14.TextTransparency = if not ReactIs.isBinding(v63) then EmphasisTransparency else v63:map(function(n10: number) -- line: 79
		-- upvalues: EmphasisTransparency (copy)
		return EmphasisTransparency + n10 * (1 - EmphasisTransparency)
	end)
	t14.TextXAlignment = Enum.TextXAlignment.Left
	t14.TextYAlignment = Enum.TextYAlignment.Center
	t14[React.Event.Focused] = v92
	t14[React.Event.FocusLost] = v93
	t14[React.Change.Text] = v95
	t12.SearchBox = createElement6("TextBox", t14, {
		Flex = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill
		})
	})
	t10.SearchField = createElement4(v107, t11, t12)
	t8.SearchContent = createElement3("CanvasGroup", t9, t10)
	t6.SearchContainer = createElement2(v100, t7, t8)

	local createElement7 = React.createElement
	local v120 = View
	local t15 = {
		Name = "ListArea",
		BorderSizePixel = 0,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 1, -Size_1200)
	}
	local t16 = {}
	local createElement8 = React.createElement
	local t17 = {
		Name = "ListContent",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		GroupTransparency = n5,
		Size = UDim2.fromScale(1, 1)
	}
	local t18 = {
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
				itemList = v76,
				loadNext = v73.loadNext,
				isLoadingNext = listStatus.isFetchingNextPage == true,
				oldestConversationIsFetched = listStatus.oldestConversationIsFetched == true or listStatus.isExhausted == true,
				onScrollUpdate = v94,
				rowProps = {
					showBackground = false,
					localUserId = t2.localUserId
				},
				localUserId = t2.localUserId,
				onActivated = v89,
				fireConversationClickedEvent = v80.fireConversationClickedEvent,
				fireConversationImpressionEvent = v80.fireConversationImpressionEvent
			})
		})
	}

	if v88 ~= nil then
		local createElement9 = React.createElement
		local v127 = View
		local t19 = {
			tag = "col align-x-center align-y-center gap-small size-full",
			BorderSizePixel = 0,
			LayoutOrder = 2
		}
		local t20 = {}
		local createElement10 = React.createElement
		local v131 = FoundationText
		local t21 = {
			tag = "auto-xy text-body-medium text-align-x-center content-default",
			Text = v88
		}
		local DefaultColor3_2 = v51.Color.Content.Default.Color3
		local DefaultTransparency2 = v51.Color.Content.Default.Transparency
		local v135 = if not ReactIs.isBinding(v63) then DefaultTransparency2 else v63:map(function(n11: number) -- line: 79
			-- upvalues: DefaultTransparency2 (copy)
			return DefaultTransparency2 + n11 * (1 - DefaultTransparency2)
		end)

		t21.textStyle = {
			Color3 = DefaultColor3_2,
			Transparency = v135
		}
		t20.Message = createElement10(v131, t21)
		t20.Retry = v81 and React.createElement(Button, {
			fillBehavior = FillBehavior.Fit,
			onActivated = v73.retryInitialFetch,
			size = InputSize.Small,
			text = t4.retry,
			variant = ButtonVariant.Standard
		}) or nil
		v136 = createElement9(v127, t19, t20)

		if v136 then
			g137 = true
		end
	end

	if not g137 then
		v136 = nil
	end

	g137 = false
	t18.Status = v136
	t16.ListContent = createElement8("CanvasGroup", t17, t18)
	t6.ListArea = createElement7(v120, t15, t16)

	return (createElement("Frame", t5, t6))
end

return React.memo(FriendsChatConversationList)
