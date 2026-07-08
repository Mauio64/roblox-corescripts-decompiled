local TextChatService = game:GetService("TextChatService")
local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local ReactIs = require(Parent.ReactIs)
local Foundation = require(Parent.Foundation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local AppChat = require(Parent.AppChat)
local useChatPlatform = require(Parent.ExpChatIntegration.useChatPlatform)
local useInterpolatedClientSettings = require(Parent.ExpChatIntegration.useInterpolatedClientSettings)
local useChatWindowSettings = require(Parent.ExpChatIntegration.useChatWindowSettings)
local ExpChatConversationListAdapter = require(script.Parent.ExpChatConversationListAdapter)
local useConversationListPagination = require(script.Parent.useConversationListPagination)
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

local function getColorStyle(p1, p2) -- line: 55
	return {
		Color3 = p1,
		Transparency = p2
	}
end
local function getTransparencyOrBindingValue(n1: number, p3) -- line: 62
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p3) then
		return p3:map(function(n2: number) -- line: 64
			-- upvalues: n1 (copy)
			return n1 + n2 * (1 - n1)
		end)
	end

	return p3
end
local function getTextTransparency(p4, n3: number) -- line: 72
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p4) then
		return p4:map(function(n4: number) -- line: 74
			-- upvalues: n3 (copy)
			return n3 + n4 * (1 - n3)
		end)
	end

	return n3
end
local function normalizeSearchText(s1: string?) -- line: 82
	return string.lower(s1 or "")
end
local function containsSearchText(s2: string?, s3: string) -- line: 86
	if s3 == "" then
		return true
	end

	return string.find(string.lower(s2 or ""), s3, 1, true) ~= nil
end
local function getLocalizedText(s4: string?, s5: string, s6: string) -- line: 93
	if s4 ~= nil and (s4 ~= "" and s4 ~= s5) then
		return s4
	end

	return s6
end
local function FriendsChatConversationList(t2: {[any]: any}) -- line: 101
	-- upvalues: useTokens (copy), useChatPlatform (copy), useChatWindowSettings (copy), React (copy), useLocalization (copy), t1 (copy), useInterpolatedClientSettings (copy), ReactIs (copy), useConversationList (copy), useConversationListPagination (copy), getConversationTitle (copy), TextChatService (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), ConversationListUltimate (copy), FoundationText (copy), Button (copy), FillBehavior (copy), InputSize (copy), ButtonVariant (copy)
	local v47 = useTokens()
	local getTransparencyStore = useChatPlatform().getTransparencyStore
	local v49 = useChatWindowSettings()
	local v50 = React.useMemo(function() -- line: 105
		-- upvalues: v49 (copy)
		return {
			BackgroundColor3 = v49.ChatWindowBackgroundColor3,
			BackgroundTransparency = v49.ChatWindowBackgroundTransparency
		}
	end, { v49 })
	local v51 = t2.chatWindowSettings or v50
	local v52 = useLocalization(t1)
	local v53 = useInterpolatedClientSettings(v51)
	local BackgroundTransparency = v53.BackgroundTransparency
	local v55 = v53.BackgroundColor3 or (v53.BackgroundColor or v51.BackgroundColor3)
	local v56 = t2.transparencyValue or v49.ChatWindowBackgroundTransparency
	local g129 = nil
	local v128 = nil
	local n5

	if t2.transparencyValue == nil then
		n5 = 0
	elseif ReactIs.isBinding(v56) then
		local n6 = 0

		n5 = v56:map(function(n7: number) -- line: 64
			-- upvalues: n6 (copy)
			return n6 + n7 * (1 - n6)
		end)
	else
		n5 = v56
	end

	local v59 = t2.textTransparency or React.createBinding(0)
	local Size_1200 = v47.Size.Size_1200
	local Size_1400 = v47.Size.Size_1400
	local v62, v63 = React.useState("")
	local v64 = t2.visible ~= false
	local v65 = useConversationList(v64)
	local v66 = useConversationListPagination(v64, v65.listStatus)
	local listStatus = v65.listStatus
	local items = v65.items
	local v69 = React.useMemo(function() -- line: 133
		-- upvalues: v62 (copy), items (copy), getConversationTitle (copy)
		local v133 = v62
		local v134 = string.lower(v133 or "")
		local t3 = {}

		for _, v137 in items do
			local v138 = getConversationTitle(v137) or (v137.title or v137.titleForViewer)
			local previewContent = v137.previewContent

			if v134 == "" or string.find(string.lower(v138 or ""), v134, 1, true) ~= nil or (v134 == "" or string.find(string.lower(previewContent or ""), v134, 1, true) ~= nil) then
				table.insert(t3, v137)
			end
		end

		return t3
	end, {
		items,
		v62
	})
	local v70 = listStatus.isFetchingConversations == true and #items == 0
	local v71 = listStatus.error ~= nil
	local v72 = v62 ~= ""
	local v73 = v71 and #items == 0
	local v74 = #v69 == 0 and (listStatus.isFetchingConversations ~= true and (#items > 0 or (listStatus.hasFetchedInitialPage == true or v73)))
	local t4 = {
		loadingConversations = "Loading conversations...",
		loadConversationsError = "Unable to load conversations.",
		noLoadedConversationsFound = "No loaded conversations found",
		noConversationsYet = "No conversations yet"
	}
	local SearchPlaceholder = v52.SearchPlaceholder
	local SearchPlaceholder2 = t1.SearchPlaceholder

	t4.searchPlaceholder = (SearchPlaceholder == nil or (SearchPlaceholder == "" or SearchPlaceholder == SearchPlaceholder2)) and "Search" or SearchPlaceholder

	local Retry = v52.Retry
	local Retry2 = t1.Retry

	t4.retry = (Retry == nil or (Retry == "" or Retry == Retry2)) and "Retry" or Retry

	local v80 = if not v70 then if not v73 then if not v74 then nil else if not v72 then t4.noConversationsYet else t4.noLoadedConversationsFound else t4.loadConversationsError else t4.loadingConversations
	local v81 = React.useCallback(function(p5) -- line: 180
		-- upvalues: t2 (copy)
		if t2.onConversationActivated == nil or (p5 == nil or p5.id == nil) then
			return
		end

		t2.onConversationActivated(p5.id)
	end, { t2.onConversationActivated })
	local v82 = React.useCallback(function(p6) -- line: 188
		-- upvalues: TextChatService (copy), t2 (copy)
		local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

		if ChatWindowConfiguration and t2.onAbsoluteSizeChanged then
			t2.onAbsoluteSizeChanged(p6, ChatWindowConfiguration)
		end
	end, { t2.onAbsoluteSizeChanged })
	local v83 = React.useCallback(function(p7) -- line: 195
		-- upvalues: TextChatService (copy), t2 (copy)
		local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

		if ChatWindowConfiguration and t2.onAbsolutePositionChanged then
			t2.onAbsolutePositionChanged(p7, ChatWindowConfiguration)
		end
	end, { t2.onAbsolutePositionChanged })
	local v84 = React.useCallback(function() -- line: 202
		-- upvalues: getTransparencyStore (copy)
		getTransparencyStore(false).setTextboxFocus()
	end, { getTransparencyStore })
	local v85 = React.useCallback(function() -- line: 206
		-- upvalues: getTransparencyStore (copy)
		getTransparencyStore(false).clearTextboxFocus()
	end, { getTransparencyStore })

	React.useEffect(function() -- line: 210
		-- upvalues: getTransparencyStore (copy)
		return function() -- line: 211
			-- upvalues: getTransparencyStore (copy)
			getTransparencyStore(false).clearTextboxFocus()
		end
	end, { getTransparencyStore })

	local v86 = React.useCallback(function(_) -- line: 216
		-- upvalues: getTransparencyStore (copy)
		getTransparencyStore(false).resetAllTransparency()
	end, { getTransparencyStore })
	local v87 = React.useCallback(function(p9) -- line: 220
		-- upvalues: v63 (copy)
		v63(p9.Text)
	end, {})
	local createElement = React.createElement
	local t5 = {
		Name = "chatWindow",
		Active = true,
		BackgroundColor3 = v55,
		BackgroundTransparency = if not ReactIs.isBinding(v56) then v56 else v56:map(function(n8: number) -- line: 64
			-- upvalues: BackgroundTransparency (copy)
			return BackgroundTransparency + n8 * (1 - BackgroundTransparency)
		end),
		BorderSizePixel = 0,
		LayoutOrder = t2.LayoutOrder or 1,
		Size = t2.size or UDim2.fromScale(1, 1),
		Visible = v64,
		[React.Change.AbsoluteSize] = v82,
		[React.Change.AbsolutePosition] = v83,
		[React.Event.MouseEnter] = t2.onHovered,
		[React.Event.MouseLeave] = t2.onUnhovered
	}
	local t6 = {
		uiSizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v49.ChatWindowMaxWidth, v49.ChatWindowMaxHeight)
		}),
		layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 0),
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}
	local createElement2 = React.createElement
	local v92 = View
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
	local v99 = View
	local t11 = {
		Name = "SearchField",
		tag = "row align-y-center gap-small padding-x-medium stroke-standard stroke-default radius-circle",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(1, 1),
		Size = UDim2.new(1, -2, 0, v47.Size.Size_800)
	}
	local t12 = {}
	local createElement5 = React.createElement
	local v103 = Icon
	local t13 = {
		LayoutOrder = 1,
		name = IconName.MagnifyingGlass,
		size = IconSize.Small
	}
	local DefaultColor3 = v47.Color.Content.Default.Color3
	local DefaultTransparency = v47.Color.Content.Default.Transparency
	local v107 = if not ReactIs.isBinding(v59) then DefaultTransparency else v59:map(function(n9: number) -- line: 74
		-- upvalues: DefaultTransparency (copy)
		return DefaultTransparency + n9 * (1 - DefaultTransparency)
	end)

	t13.style = {
		Color3 = DefaultColor3,
		Transparency = v107
	}
	t12.SearchIcon = createElement5(v103, t13)

	local createElement6 = React.createElement
	local t14 = {
		Name = "FriendsChatConversationListSearchBox",
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		Font = v47.Typography.BodySmall.Font,
		LineHeight = v47.Typography.BodySmall.LineHeight,
		LayoutOrder = 2,
		PlaceholderColor3 = v47.Color.Content.Muted.Color3,
		PlaceholderText = t4.searchPlaceholder,
		Size = UDim2.new(0, 0, 1, 0),
		Text = v62,
		TextColor3 = v47.Color.Content.Emphasis.Color3,
		TextSize = v47.Typography.BodySmall.FontSize
	}
	local EmphasisTransparency = v47.Color.Content.Emphasis.Transparency

	t14.TextTransparency = if not ReactIs.isBinding(v59) then EmphasisTransparency else v59:map(function(n10: number) -- line: 74
		-- upvalues: EmphasisTransparency (copy)
		return EmphasisTransparency + n10 * (1 - EmphasisTransparency)
	end)
	t14.TextXAlignment = Enum.TextXAlignment.Left
	t14.TextYAlignment = Enum.TextYAlignment.Center
	t14[React.Event.Focused] = v84
	t14[React.Event.FocusLost] = v85
	t14[React.Change.Text] = v87
	t12.SearchBox = createElement6("TextBox", t14, {
		Flex = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill
		})
	})
	t10.SearchField = createElement4(v99, t11, t12)
	t8.SearchContent = createElement3("CanvasGroup", t9, t10)
	t6.SearchContainer = createElement2(v92, t7, t8)

	local createElement7 = React.createElement
	local v112 = View
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
		List = React.createElement(ConversationListUltimate, {
			LayoutOrder = 1,
			isWideMode = false,
			showHeaderEntries = false,
			shouldLogHeaderEntryExposures = false,
			Size = UDim2.fromScale(1, 1),
			entryHeight = Size_1400,
			itemList = v69,
			loadNext = v66.loadNext,
			isLoadingNext = listStatus.isFetchingNextPage == true,
			oldestConversationIsFetched = listStatus.oldestConversationIsFetched == true or listStatus.isExhausted == true,
			onScrollUpdate = v86,
			rowProps = {
				showBackground = false,
				localUserId = t2.localUserId
			},
			localUserId = t2.localUserId,
			onActivated = v81
		})
	}

	if v80 ~= nil then
		local createElement9 = React.createElement
		local v119 = View
		local t19 = {
			tag = "col align-x-center align-y-center gap-small size-full",
			BorderSizePixel = 0,
			LayoutOrder = 2
		}
		local t20 = {}
		local createElement10 = React.createElement
		local v123 = FoundationText
		local t21 = {
			tag = "auto-xy text-body-medium text-align-x-center content-default",
			Text = v80
		}
		local DefaultColor3_2 = v47.Color.Content.Default.Color3
		local DefaultTransparency2 = v47.Color.Content.Default.Transparency
		local v127 = if not ReactIs.isBinding(v59) then DefaultTransparency2 else v59:map(function(n11: number) -- line: 74
			-- upvalues: DefaultTransparency2 (copy)
			return DefaultTransparency2 + n11 * (1 - DefaultTransparency2)
		end)

		t21.textStyle = {
			Color3 = DefaultColor3_2,
			Transparency = v127
		}
		t20.Message = createElement10(v123, t21)
		t20.Retry = v73 and React.createElement(Button, {
			fillBehavior = FillBehavior.Fit,
			onActivated = v66.retryInitialFetch,
			size = InputSize.Small,
			text = t4.retry,
			variant = ButtonVariant.Standard
		}) or nil
		v128 = createElement9(v119, t19, t20)

		if v128 then
			g129 = true
		end
	end

	if not g129 then
		v128 = nil
	end

	g129 = false
	t18.Status = v128
	t16.ListContent = createElement8("CanvasGroup", t17, t18)
	t6.ListArea = createElement7(v112, t15, t16)

	return (createElement("Frame", t5, t6))
end

return React.memo(FriendsChatConversationList)
