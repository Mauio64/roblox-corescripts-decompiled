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
local function mergeTransparency(n5: number, t2: {[any]: any}) -- line: 87
	-- upvalues: ReactIs (copy), React (copy)
	local t3 = {}
	local u48 = n5

	for _, v50 in t2 do
		if ReactIs.isBinding(v50) then
			table.insert(t3, v50)
		else
			u48 += (v50 or 0) * (1 - u48)
		end
	end

	if #t3 == 0 then
		return u48
	end

	return React.joinBindings(t3):map(function(p5) -- line: 103
		-- upvalues: u48 (ref)
		local v131 = u48

		for _, v133 in p5 do
			v131 += v133 * (1 - v131)
		end

		return v131
	end)
end
local function normalizeSearchText(s1: string?) -- line: 112
	return string.lower(s1 or "")
end
local function containsSearchText(s2: string?, s3: string) -- line: 116
	if s3 == "" then
		return true
	end

	return string.find(string.lower(s2 or ""), s3, 1, true) ~= nil
end
local function getLocalizedText(s4: string?, s5: string, s6: string) -- line: 123
	if s4 ~= nil and (s4 ~= "" and s4 ~= s5) then
		return s4
	end

	return s6
end
local function FriendsChatConversationList(t4: {[any]: any}) -- line: 131
	-- upvalues: useTokens (copy), useChatPlatform (copy), useChatWindowSettings (copy), React (copy), useLocalization (copy), t1 (copy), useInterpolatedClientSettings (copy), ReactIs (copy), mergeTransparency (copy), useChatInputBarSettings (copy), LayoutConstants (copy), useConversationList (copy), useConversationListPagination (copy), getConversationTitle (copy), useFriendsChatLandingTelemetry (copy), TextChatService (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), ConversationListUltimate (copy), FoundationText (copy), Button (copy), FillBehavior (copy), InputSize (copy), ButtonVariant (copy)
	local v58 = useTokens()
	local getTransparencyStore = useChatPlatform().getTransparencyStore
	local v60 = useChatWindowSettings()
	local v61 = React.useMemo(function() -- line: 135
		-- upvalues: v60 (copy)
		return {
			BackgroundColor3 = v60.ChatWindowBackgroundColor3,
			BackgroundTransparency = v60.ChatWindowBackgroundTransparency
		}
	end, { v60 })
	local v62 = t4.chatWindowSettings or v61
	local v63 = useLocalization(t1)
	local v64 = useInterpolatedClientSettings(v62)
	local BackgroundTransparency = v64.BackgroundTransparency
	local v66 = v64.BackgroundColor3 or (v64.BackgroundColor or v62.BackgroundColor3)
	local v67 = t4.transparencyValue or v60.ChatWindowBackgroundTransparency
	local g127 = nil
	local v126 = nil
	local n6

	if t4.transparencyValue == nil then
		n6 = 0
	elseif ReactIs.isBinding(v67) then
		local n7 = 0

		n6 = v67:map(function(n8: number) -- line: 69
			-- upvalues: n7 (copy)
			return n7 + n8 * (1 - n7)
		end)
	else
		n6 = v67
	end

	local v70 = t4.textTransparency or React.createBinding(0)
	local v71 = mergeTransparency(v58.Color.Content.Default.Transparency, {
		v70,
		n6
	})
	local v72 = mergeTransparency(v58.Color.Content.Emphasis.Transparency, {
		v70,
		n6
	})
	local v73 = mergeTransparency(v58.Color.Stroke.Default.Transparency, { n6 })
	local Size_1200 = v58.Size.Size_1200
	local Size_1400 = v58.Size.Size_1400
	local v76 = useChatInputBarSettings()
	local v77 = ((if not t4.isSpatialUIEnabled or (not v76 or not v76.SpatialPanelTextSize) then (if not v76 then v58.Typography.CaptionMedium.FontSize else v76.TextSize) else v76.SpatialPanelTextSize)) or v58.Typography.CaptionMedium.FontSize
	local v78 = LayoutConstants.InputBarTopPadding + LayoutConstants.InputBarBottomPadding + LayoutConstants.InputBarTextVerticalPadding + v77
	local v79, v80 = React.useState("")
	local v81 = t4.visible ~= false
	local v82 = useConversationList(v81)
	local v83 = useConversationListPagination(v81, v82.listStatus)
	local listStatus = v82.listStatus
	local items = v82.items
	local v86 = React.useMemo(function() -- line: 181
		-- upvalues: v79 (copy), items (copy), getConversationTitle (copy)
		local v135 = v79
		local v136 = string.lower(v135 or "")
		local t5 = {}

		for _, v139 in items do
			local v140 = getConversationTitle(v139) or (v139.title or v139.titleForViewer)
			local previewContent = v139.previewContent

			if v136 == "" or string.find(string.lower(v140 or ""), v136, 1, true) ~= nil or (v136 == "" or string.find(string.lower(previewContent or ""), v136, 1, true) ~= nil) then
				table.insert(t5, v139)
			end
		end

		return t5
	end, {
		items,
		v79
	})
	local v87 = listStatus.isFetchingConversations == true and #items == 0
	local v88 = listStatus.error ~= nil
	local v89 = v79 ~= ""
	local v90 = useFriendsChatLandingTelemetry({
		conversations = items,
		displayedConversations = v86,
		isFiltered = v89
	})
	local v91 = v88 and #items == 0
	local v92 = #v86 == 0 and (listStatus.isFetchingConversations ~= true and (#items > 0 or (listStatus.hasFetchedInitialPage == true or v91)))
	local t6 = {
		loadingConversations = "Loading conversations...",
		loadConversationsError = "Unable to load conversations.",
		noLoadedConversationsFound = "No loaded conversations found",
		noConversationsYet = "No conversations yet"
	}
	local SearchPlaceholder = v63.SearchPlaceholder
	local SearchPlaceholder2 = t1.SearchPlaceholder

	t6.searchPlaceholder = (SearchPlaceholder == nil or (SearchPlaceholder == "" or SearchPlaceholder == SearchPlaceholder2)) and "Search" or SearchPlaceholder

	local Retry = v63.Retry
	local Retry2 = t1.Retry

	t6.retry = (Retry == nil or (Retry == "" or Retry == Retry2)) and "Retry" or Retry

	local v98 = if not v87 then if not v91 then if not v92 then nil else if not v89 then t6.noConversationsYet else t6.noLoadedConversationsFound else t6.loadConversationsError else t6.loadingConversations
	local v99 = React.useCallback(function(p6) -- line: 234
		-- upvalues: t4 (copy)
		if t4.onConversationActivated == nil or (p6 == nil or p6.id == nil) then
			return
		end

		t4.onConversationActivated(p6.id)
	end, { t4.onConversationActivated })
	local v100 = React.useCallback(function(p7) -- line: 242
		-- upvalues: TextChatService (copy), t4 (copy)
		local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

		if ChatWindowConfiguration and t4.onAbsoluteSizeChanged then
			t4.onAbsoluteSizeChanged(p7, ChatWindowConfiguration)
		end
	end, { t4.onAbsoluteSizeChanged })
	local v101 = React.useCallback(function(p8) -- line: 249
		-- upvalues: TextChatService (copy), t4 (copy)
		local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

		if ChatWindowConfiguration and t4.onAbsolutePositionChanged then
			t4.onAbsolutePositionChanged(p8, ChatWindowConfiguration)
		end
	end, { t4.onAbsolutePositionChanged })
	local v102 = React.useCallback(function() -- line: 256
		-- upvalues: v90 (copy), getTransparencyStore (copy)
		v90.fireSearchActivatedEvent()
		getTransparencyStore(false).setTextboxFocus()
	end, {
		getTransparencyStore,
		v90.fireSearchActivatedEvent
	})
	local v103 = React.useCallback(function() -- line: 261
		-- upvalues: getTransparencyStore (copy)
		getTransparencyStore(false).clearTextboxFocus()
	end, { getTransparencyStore })

	React.useEffect(function() -- line: 265
		-- upvalues: getTransparencyStore (copy)
		return function() -- line: 266
			-- upvalues: getTransparencyStore (copy)
			getTransparencyStore(false).clearTextboxFocus()
		end
	end, { getTransparencyStore })

	local v104 = React.useCallback(function(_) -- line: 271
		-- upvalues: getTransparencyStore (copy)
		getTransparencyStore(false).resetAllTransparency()
	end, { getTransparencyStore })
	local v105 = React.useCallback(function(p10) -- line: 275
		-- upvalues: v80 (copy)
		v80(p10.Text)
	end, {})
	local createElement = React.createElement
	local t7 = {
		Name = "chatWindow",
		Active = true,
		BackgroundColor3 = v66,
		BackgroundTransparency = if not ReactIs.isBinding(v67) then v67 else v67:map(function(n9: number) -- line: 69
			-- upvalues: BackgroundTransparency (copy)
			return BackgroundTransparency + n9 * (1 - BackgroundTransparency)
		end),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = t4.LayoutOrder or 1,
		Size = t4.size or UDim2.new(1, 0, 1, LayoutConstants.PanelTopSpacerHeight + v78 + LayoutConstants.PanelBottomCornerRadius),
		Visible = v81,
		[React.Change.AbsoluteSize] = v100,
		[React.Change.AbsolutePosition] = v101,
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
					Size = UDim2.new(1, -2, 0, v58.Size.Size_800),
					stroke = {
						Color = v58.Color.Stroke.Default.Color3,
						Transparency = v73,
						Thickness = v58.Stroke.Standard
					}
				}, {
					SearchIcon = React.createElement(Icon, {
						LayoutOrder = 1,
						name = IconName.MagnifyingGlass,
						size = IconSize.Small,
						style = {
							Color3 = v58.Color.Content.Default.Color3,
							Transparency = v71
						}
					}),
					SearchBox = React.createElement("TextBox", {
						Name = "FriendsChatConversationListSearchBox",
						BackgroundTransparency = 1,
						ClearTextOnFocus = false,
						Font = v58.Typography.BodySmall.Font,
						LineHeight = v58.Typography.BodySmall.LineHeight,
						LayoutOrder = 2,
						PlaceholderColor3 = v58.Color.Content.Muted.Color3,
						PlaceholderText = t6.searchPlaceholder,
						Size = UDim2.new(0, 0, 1, 0),
						Text = v79,
						TextColor3 = v58.Color.Content.Emphasis.Color3,
						TextSize = v58.Typography.BodySmall.FontSize,
						TextTransparency = v72,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						[React.Event.Focused] = v102,
						[React.Event.FocusLost] = v103,
						[React.Change.Text] = v105
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
	local v110 = View
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
				itemList = v86,
				loadNext = v83.loadNext,
				isLoadingNext = listStatus.isFetchingNextPage == true,
				oldestConversationIsFetched = listStatus.oldestConversationIsFetched == true or listStatus.isExhausted == true,
				onScrollUpdate = v104,
				rowProps = {
					showBackground = false,
					localUserId = t4.localUserId
				},
				localUserId = t4.localUserId,
				onActivated = v99,
				fireConversationClickedEvent = v90.fireConversationClickedEvent,
				fireConversationImpressionEvent = v90.fireConversationImpressionEvent
			})
		})
	}

	if v98 ~= nil then
		local createElement4 = React.createElement
		local v117 = View
		local t13 = {
			tag = "col align-x-center align-y-center gap-small size-full",
			BorderSizePixel = 0,
			LayoutOrder = 2
		}
		local t14 = {}
		local createElement5 = React.createElement
		local v121 = FoundationText
		local t15 = {
			tag = "auto-xy text-body-medium text-align-x-center content-default",
			Text = v98
		}
		local DefaultColor3 = v58.Color.Content.Default.Color3
		local DefaultTransparency = v58.Color.Content.Default.Transparency
		local v125 = if not ReactIs.isBinding(v70) then DefaultTransparency else v70:map(function(n10: number) -- line: 79
			-- upvalues: DefaultTransparency (copy)
			return DefaultTransparency + n10 * (1 - DefaultTransparency)
		end)

		t15.textStyle = {
			Color3 = DefaultColor3,
			Transparency = v125
		}
		t14.Message = createElement5(v121, t15)
		t14.Retry = v91 and React.createElement(Button, {
			fillBehavior = FillBehavior.Fit,
			onActivated = v83.retryInitialFetch,
			size = InputSize.Small,
			text = t6.retry,
			variant = ButtonVariant.Standard
		}) or nil
		v126 = createElement4(v117, t13, t14)

		if v126 then
			g127 = true
		end
	end

	if not g127 then
		v126 = nil
	end

	g127 = false
	t12.Status = v126
	t10.ListContent = createElement3("CanvasGroup", t11, t12)
	t8.ListArea = createElement2(v110, t9, t10)

	return (createElement("Frame", t7, t8))
end

return React.memo(FriendsChatConversationList)
